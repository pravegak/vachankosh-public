import 'package:flutter/material.dart';
import 'package:vachankosh/constants/app_data.dart';
import 'package:vachankosh/utils/helper_functions.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';

class RequestHeader extends StatelessWidget {
  const RequestHeader({
    Key key,
    @required this.req,
  }) : super(key: key);

  final MedicineRequest req;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
      child: Column(
        children: <Widget>[
          Text(
            req.requestId != null
                ? '#' + req.requestId.toString().padLeft(3, '0')
                : '#12385',
            style: TextStyle(color: Colors.black54, fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'Created on',
                    style: TextStyle(color: Colors.black45),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    req.timestamps != null &&
                            req.timestamps.containsKey('createdAt')
                        ? getDateString(req.timestamps['createdAt'].toDate())
                        : '31-07-2020',
                    style: TextStyle(),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Status',
                    style: TextStyle(color: Colors.black45),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    req.status,
                    style: TextStyle(
                        color: req.status == RequestStatus.NEW
                            ? Colors.red
                            : req.status == RequestStatus.UNDER_VERIFICATION
                                ? Colors.blue
                                : Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          if (req.status == RequestStatus.VERIFIED)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Verified by',
                      style: TextStyle(color: Colors.black45),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      req.verifiedByVolunteer,
                      style: TextStyle(),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
