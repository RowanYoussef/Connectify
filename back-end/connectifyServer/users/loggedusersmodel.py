from django.db import models

class LoggedUsersModel(models.Model):
    email = models.CharField(max_length=255,null = False,unique=True)
    phone = models.CharField(max_length=15 , null=False,unique=True)
    token = models.CharField(max_length=8)