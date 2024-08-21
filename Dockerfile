FROM python:3.9-slim-bookworm

RUN apt update && apt install git -y && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/rss2email/rss2email.git

WORKDIR /rss2email

RUN pip install . && r2e new admin@example.com

RUN sed -i -e 's/email-protocol = sendmail/email-protocol = smtp/' \
    -e 's/smtp-auth = False/smtp-auth = True/' \
    /root/.config/rss2email.cfg

COPY --chmod=755 ./entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
