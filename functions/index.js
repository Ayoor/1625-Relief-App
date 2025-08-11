"use strict";

const functions = require("firebase-functions/v1");
//const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const moment = require('moment');  // To handle dates

// Function 1: Shift Notification (3 Hours Before)
exports.checkShiftsAndNotify = functions.pubsub.schedule('every 30 minutes').onRun(async (context) => {
  // Get the current date and time
  const now = moment();

  // Reference to the 'Shifts' data for all users
  const shiftsRef = admin.database().ref('Users');

  const snapshot = await shiftsRef.once('value');

  snapshot.forEach(async (userSnapshot) => {
    const email = userSnapshot.key;  // User email

    const shifts = userSnapshot.child('Shifts').val();

    if (shifts) {
      // Check each shift
      for (const shiftDate in shifts) {
        const shiftStartTime = moment(shifts[shiftDate].startTime);

        // Check if the shift is in 3 hours
        if (shiftStartTime.diff(now, 'hours') === 3) {
          const tokens = userSnapshot.child('FcmTokens').val();

          if (tokens && tokens.length > 0) {
            const payload = {
              notification: {
                title: 'Upcoming Shift!',
                body: 'You have a shift starting in 3 hours. Get ready!',
              },
            };

            // Send notification to all devices of the user
            await admin.messaging().sendMulticast({
              tokens: tokens,
              notification: payload.notification,
            });

            console.log(`Notification sent to ${email} for shift starting in 3 hours`);
          }
        }
      }
    }
  });

  return null;  // End of function
});

// Function 2: Timesheet Reminder (9th of Every Month at 9 AM)
exports.sendTimesheetReminder = functions.pubsub.schedule('0 9 9 * *').onRun(async (context) => {
  // Reference to the 'Users' data
  const usersRef = admin.database().ref('Users');

  const snapshot = await usersRef.once('value');

  snapshot.forEach(async (userSnapshot) => {
    const email = userSnapshot.key;  // User email
    const tokens = userSnapshot.child('FcmTokens').val();

    if (tokens && tokens.length > 0) {
      const payload = {
        notification: {
          title: 'Timesheet Reminder',
          body: 'Please submit your timesheet for this month.',
        },
      };

      // Send notification to all devices of the user
      await admin.messaging().sendMulticast({
        tokens: tokens,
        notification: payload.notification,
      });

      console.log(`Timesheet reminder sent to ${email}`);
    }
  });

  return null;  // End of function
});
