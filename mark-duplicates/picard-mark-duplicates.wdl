workflow picdup_workflow {

    File bam
    String results_folder

    call picard_task as picard_call {
        input:
            bam = bam
    }
    call copy_task as picard_copy_call {
        input:
            files = [picard_call.out1, picard_call.out2],
            destination = results_folder
    }

}

task picard_task {
    File bam

    command {
        picard MarkDuplicates \
        I=${bam} \
        O=marked_bam.bam \
        M=metrics.txt \
        MODE=SUMMARY
    }

    runtime {
        docker: "biocontainers/picard@sha256:1dc72c0ffb8885428860fa97e00f1dd868e8b280f6b7af820a0418692c14ae00"
      }

    output {
        File out1 = "metrics.txt"
        File out2 = "marked_bam.bam"
      }

}


task copy_task {
    Array[File] files
    String destination

    command {
        mkdir -p ${destination}
        cp -L -R -u ${sep=' ' files} ${destination}
    }

    output {
        Array[File] out = files
    }
}
