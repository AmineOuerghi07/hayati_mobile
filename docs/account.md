# Account

Hayati works without an account. Habits stay on the device until you sign in, and then they move onto that account. Signing out opens a fresh empty guest space, so the previous account is not left on the screen. Signing back in brings that account's habits back.

There is no SMS provider and no Supabase client. The account store is a local stand-in behind `AuthRepository`. A later adapter can replace `authRepositoryProvider`.

The local demo code is a six-digit code created on the device. The verify and reset screens show it only in the dev flavor, with the label "Local demo code". The app never says an email or a text was sent.

Email sign-in, account creation, the code flow, forgot password, change password, sign-out, and account deletion all go through the same repository. Passwords are stored as a salted hash.
