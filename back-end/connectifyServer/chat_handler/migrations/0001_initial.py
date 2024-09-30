# Generated by Django 5.1.1 on 2024-09-30 15:51

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Message',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('signal', models.IntegerField(default=0, null=False)),
                ('sender', models.CharField(max_length=255, null=False)),
                ('receiver', models.CharField(max_length=255, null=False)),
                ('hasattachment', models.IntegerField(default=0, null=False)),
                ('text', models.CharField(max_length=1000, null=True)),
                ('attachment_name', models.CharField(max_length=255, null=True)),
                ('attachment', models.CharField(max_length=255, null=True)),
                ('message_id', models.CharField(null = False)),
                ('time', models.CharField(max_length=255, null=True)),
            ],
        ),
    ]
