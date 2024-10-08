import sentry_sdk

sentry_sdk.init(
    dsn="https://ceccce926a95549482d140866c2d2643@o4506853648236544.ingest.us.sentry.io/4506854395478016",
    environment="development",
    release="1.0"
)

if __name__ == "__main__":
    division_zero = 1 /0