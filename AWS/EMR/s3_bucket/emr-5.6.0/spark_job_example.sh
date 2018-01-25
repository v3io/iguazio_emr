#!/bin/bash
echo "$(date) started job"
#spark-submit --executor-memory 2G --master yarn --num-executors 12 --packages com.databricks:spark-avro_2.11:3.2.0 --conf "spark.driver.extraJavaOptions=-Dv3io.config.kv.update.max-in-flight=128" --conf "spark.executor.extraJavaOptions=-Dv3io.config.kv.update.max-in-flight=128" --class emd.PassengerFirstLastBooking /opt/igz/spark/lib/spark2-apps.jar v3io:////taxi-types-v/*/* v3io:////bookings/ v3io:////first-last-emd-output

#spark fast test
#spark-submit --executor-memory 1G --master yarn --num-executors 12 --packages com.databricks:spark-avro_2.11:3.2.0 --class emd.PassengerFirstLastBooking /opt/igz/spark/lib/spark2-apps.jar v3io:////taxi-types-v/*/* v3io:////bookings/year=2016/month=08/day=01/bookings-20160801.avro v3io:////first-last-emd-output

#spark-submit --executor-memory 6G --master yarn --num-executors 12 --packages com.databricks:spark-avro_2.11:3.2.0  --class emd.PassengerFirstLastBooking /opt/igz/spark/lib/spark2-apps.jar v3io:////taxi-types-v/*/* v3io:////bookings/ v3io:////first-last-emd-output


#echo "$(date) finished job"
#spark-submit --executor-memory 6G --master yarn --num-executors 12 --packages com.databricks:spark-avro_2.11:3.2.0  --conf "spark.driver.extraJavaOptions=-Dv3io.config.kv.update.max-in-flight=1" --conf "spark.executor.extraJavaOptions=-Dv3io.config.kv.update.max-in-flight=1" --class emd.PassengerFirstLastBooking /opt/igz/spark/lib/spark2-apps.jar v3io:////taxi-types-v/*/* v3io:////bookings/ v3io:////first-last-emd-output

#spark-submit -v \
# --executor-memory 2G \
# --master yarn \
# --num-executors 12 \
# --executor-cores 1 \
# --packages com.databricks:spark-avro_2.11:3.2.0 \
# --conf "spark.driver.extraJavaOptions=-Dv3io.config.kv.update.max-in-flight=1" \
# --conf "spark.executor.extraJavaOptions=-Dv3io.config.kv.update.max-in-flight=1" \
# --class emd.PassengerFirstLastBooking /opt/igz/spark/lib/spark2-apps.jar v3io:////taxi-types-v/*/* v3io:////bookings/ v3io:////first-last-emd-output

#### run 2014 job
# spark-submit -v \
# --executor-memory 2G \
# --master yarn \
# --num-executors 3 \
# --executor-cores 1 \
# --files first-last-booking.conf \
# --conf "spark.driver.extraJavaOptions=\
#   -Dconfig.file=first-last-booking.conf \
#   -Dlog4j.configuration=file:/tmp/debug/log4j-driver.properties" \
# --conf "spark.executor.extraJavaOptions= \
#   -DIGUAZIO_METRICS_COLLECTOR_CYCLE_ACTIVE=true \
#   -DIGUAZIO_METRICS_COLLECTOR_ACTIVE=true \
#   -DIGUAZIO_METRICS_COLLECTOR="log" \
#   -Dconfig.resource=first-last-booking.conf \
#   -Dlog4j.configuration=file:/tmp/debug/log4j-executor.properties \
#   -Dv3io.config.kv.update.max-in-flight=32" \
# --packages com.databricks:spark-avro_2.11:3.2.0 \
# --class emd.PassengerFirstLastBooking \
# spark2-apps.jar \
# v3io:////taxi-types-v/*/* \
# v3io:///bookings/year=2014/ \
# v3io:////first-last-emd-output


#tests
sudo su iguazio -c "spark-submit --executor-memory 6G --master yarn --num-executors 3 --packages com.databricks:spark-avro_2.11:3.2.0  --class emd.PassengerFirstLastBooking /opt/igz/spark/lib/spark2-apps.jar v3io:////taxi-types-v/*/* v3io:///bookings/year=2014 v3io:////first-last-emd-output$(date +%s) "
 
#spark-submit --executor-memory 6G --master yarn --num-executors 6 --packages com.databricks:spark-avro_2.11:3.2.0  --class emd.PassengerFirstLastBooking /opt/igz/spark/lib/spark2-apps.jar v3io:////taxi-types-v/*/* v3io:///bookings/year=2014 v3io:////first-last-emd-output2
#spark-submit --executor-memory 6G --master yarn --num-executors 9 --packages com.databricks:spark-avro_2.11:3.2.0  --class emd.PassengerFirstLastBooking /opt/igz/spark/lib/spark2-apps.jar v3io:////taxi-types-v/*/* v3io:///bookings/year=2014 v3io:////first-last-emd-output3
