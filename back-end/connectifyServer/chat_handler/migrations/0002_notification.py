# Generated by Django 5.1.1 on 2024-10-08 21:04

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('chat_handler', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Notification',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('userPhone', models.CharField(max_length=255)),
                ('fcm_token', models.CharField()),
            ],
        ),
    ]
