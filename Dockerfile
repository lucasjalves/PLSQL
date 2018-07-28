FROM sath89/oracle-12c

MAINTAINER Lucas Julio Alves da Costa

RUN apt-get install vim

COPY . /u01/app/oracle

EXPOSE 1521