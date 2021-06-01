import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vachankosh/constants/app_data.dart';
import 'package:vachankosh/utils/helper_functions.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';

class RequestTile extends StatelessWidget {
  final MedicineRequest request;
  final Function() onTap;

  const RequestTile({
    Key key,
    @required this.request,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      request.requestId != null
                          ? '#' + request.requestId.toString().padLeft(3, '0')
                          : '#12345',
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: request.status == RequestStatus.NEW
                              ? Colors.red
                              : request.status ==
                                      RequestStatus.UNDER_VERIFICATION
                                  ? Colors.amber
                                  : request.status == RequestStatus.VERIFIED
                                      ? Colors.green
                                      : request.status ==
                                              RequestStatus.IN_PROGRESS
                                          ? Colors.blue
                                          : Colors.purpleAccent,
                          borderRadius: BorderRadius.circular(4)),
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: Text(
                        request.status,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Patient',
                          style: TextStyle(color: Colors.black45),
                        ),
                        Text(request.patientName),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Amount Required',
                          style: TextStyle(color: Colors.black45),
                        ),
                        Text('₹ ${request.cost.toString()}',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Created on',
                          style: TextStyle(color: Colors.black45),
                        ),
                        Text(
                          request.timestamps != null &&
                                  request.timestamps.containsKey('createdAt')
                              ? getDateString(
                                  request.timestamps['createdAt'].toDate())
                              : '31-07-2020',
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'State',
                          style: TextStyle(color: Colors.black45),
                        ),
                        Text(request.patientState),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
