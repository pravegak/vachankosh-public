import 'package:flutter/material.dart';
import 'package:vachankosh/constants/app_styles.dart';

const String aboutIdea = """
The difficult period of the pandemic has brought humans closer to each other. There are millions of people who need help and thousands who are going out of their way to help them.

As Manish Mundra once aptly said: "This is the Indianness which we all have." Caring about others, feeling their pain, and attaching it to oneself. This is not something which we developed during the pandemic, this has been in our roots, in our cultures. It's rightly said "Nar Seva Narayan Seva".

Many want to help and much more who needs help. However, there is no way to connect the needy with the person who can help.

Vachankosh tries to address all these issues by building a promise bank and connecting needy with helpers. People register and make promises about things they can help with. In the future, whenever any help request comes, we connect the needy with them. We don't take money or other things directly or in advance.

Some good examples are promising 5000 rupees every year for medicines, 20 sanitary napkins each month, textbooks for 4 students each year, etc.

All promises related to money will be used for helping people with medicines and nothing else for now.

We are serving as a platform to connect people who can help with those who need it.

The idea is a brainchild of Arun Bothra who is an IPS officer in Odisha and also quite famous on twitter for his humanitarian work and sarcasm.
""";

const String howItWorks = """
The platform supports both offering help and asking for help.

The person who wants to help registers as a volunteer and fill their details about what they can promise and whether they can help in their locality, donate blood, etc. We store that information with us and then show you related help requests which are coming where you can offer help.

People who need help can create a help request uploading all the required details. That request will be stored on our server and shown to people who can help in their Feed.

The flow of a help request is as follows:

Each new request will require verification before any help can be offered on that. For this, help will be taken from people who volunteered to help on the ground.

Once the request is marked as verified from them, people can offer help from the promise they have made.

Once the help is offered, contact details of the help offerers will be shared with the needy person and they will be approached to do the remaining.

Vachankosh neither supports nor encourages any transactions on the platform. We only serve by connecting people.
""";

const String credits = """
The idea of building a promise bank came from Arun Bothra, an IPS officer in Odisha.

Various images used in the application are copyrighted by freepik.com. Application developers don't own them.

Thanks to friends who contributed their free/family time and helped to test the application.
""";

const String aboutDev = """
The platform is voluntarily developed with love and a zeal to help others by Pravegak Technologies. We can be reached out at contact@pravegak.in.
""";

class AboutAppView extends StatelessWidget {
  static const routeName = '/aboutApp';

  const AboutAppView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About VachanKosh"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 12,
              ),
              Text(
                "Idea",
                style: AppStyles.k24BlueHeading,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                aboutIdea,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'How it works',
                style: AppStyles.k24BlueHeading,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                howItWorks,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Credits',
                style: AppStyles.k24BlueHeading,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                credits,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'About developers',
                style: AppStyles.k24BlueHeading,
              ),
              SizedBox(
                height: 6,
              ),
              Text(aboutDev, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
