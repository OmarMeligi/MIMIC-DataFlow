import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class AgeMapper extends Mapper<Object, Text, Text, IntWritable> {
    private static final Text ageKey = new Text("age");

    @Override
    protected void map(Object key, Text value, Context context) throws IOException, InterruptedException {
        String line = value.toString();
        if (line.startsWith("subject_id")) return;  // skip header

        String[] fields = line.split(",", -1);
        if (fields.length < 4) return;

        try {
            String dob = fields[2];
            String dod = fields[3];

            int birthYear = Integer.parseInt(dob.substring(0, 4));
            int deathYear = (dod != null && !dod.isEmpty()) ? Integer.parseInt(dod.substring(0, 4)) : 2012;

            int age = deathYear - birthYear;
            if (age > 0 && age < 130)  // sanity check
                context.write(ageKey, new IntWritable(age));
        } catch (Exception e) {
            // skip invalid lines
        }
    }
}
