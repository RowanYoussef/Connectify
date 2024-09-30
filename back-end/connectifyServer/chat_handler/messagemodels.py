from django.db import models

# Create your models here.
class Message(models.Model):
    signal = models.IntegerField(default=0, null=False)
    sender = models.CharField(max_length=255, null=False)
    receiver = models.CharField(max_length=255, null=False)
    hasattachment = models.IntegerField(default=0, null=False)
    text = models.CharField(max_length=1000, null=True)
    attachment_name = models.CharField(max_length=255, null=True)
    attachment = models.CharField(max_length=255, null=True)  
    message_id = models.CharField(null = False)
    time = models.CharField(max_length=255, null=True)
