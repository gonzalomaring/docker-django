FROM gonzalomarin/base_practica
WORKDIR /usr/src/app
MAINTAINER Gonzalo Marin Gomez
#RUN pip install django mysqlclient && git clone https://github.com/gonzalomaring/docker-django.git /usr/src/app && mkdir static
RUN export http_proxy=http://172.29.0.1:8888 && git clone https://github.com/gonzalomaring/docker-django.git
ADD django_polls.sh /usr/src/app
RUN chmod +x /usr/src/app/django_polls.sh
ENV ALLOWED_HOSTS=*
ENV HOST=mariadb
ENV USUARIO=django
ENV CONTRA=django
ENV BASE_DATOS=django
ENV DJANGO_SUPERUSER_PASSWORD=admin
ENV DJANGO_SUPERUSER_USERNAME=admin
ENV DJANGO_SUPERUSER_EMAIL=admin@example.org
CMD ["/usr/src/app/django_polls.sh"]
