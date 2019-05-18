from .common import *

MEDIA_URL = "http://taiga.carril.io/media/"
STATIC_URL = "http://taiga.carril.io/static/"
SITES["front"]["scheme"] = "http"
SITES["front"]["domain"] = "taiga.carril.io"

SECRET_KEY = "ef808c4429e5395e0938967afed15727eaf3bfa68cc40e3165f1f3353f4b2ce9"

DEBUG = True
PUBLIC_REGISTER_ENABLED = False

DEFAULT_FROM_EMAIL = "no-reply@carril.io"
SERVER_EMAIL = DEFAULT_FROM_EMAIL

#CELERY_ENABLED = True

EVENTS_PUSH_BACKEND = "taiga.events.backends.rabbitmq.EventsPushBackend"
EVENTS_PUSH_BACKEND_OPTIONS = {"url": "amqp://taiga:PASSWORD_FOR_EVENTS@localhost:5672/taiga"}

# Uncomment and populate with proper connection parameters
# for enable email sending. EMAIL_HOST_USER should end by @domain.tld
#EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"
#EMAIL_USE_TLS = False
#EMAIL_HOST = "localhost"
#EMAIL_HOST_USER = ""
#EMAIL_HOST_PASSWORD = ""
#EMAIL_PORT = 25

# Uncomment and populate with proper connection parameters
# for enable github login/singin.
#GITHUB_API_CLIENT_ID = "yourgithubclientid"
#GITHUB_API_CLIENT_SECRET = "yourgithubclientsecret"