Date: Fri, 7 Sep 2018 10:02:40 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Joe Perches <joe@perches.com>
CC: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>, Andy Shevchenko
	<andy.shevchenko@gmail.com>, "maintainer:X86 ARCHITECTURE (32-BIT AND
 64-BIT)" <x86@kernel.org>, Platform Driver
	<platform-driver-x86@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	<serge.ayoun@intel.com>, <shay.katz-zamir@intel.com>, "Siddha, Suresh B"
	<suresh.b.siddha@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Darren Hart
	<dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Herbert Xu
	<herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@google.com>, "Linux
 Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 11/13] platform/x86: Intel SGX driver
Message-ID: <20180907170240.GA21376@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-12-jarkko.sakkinen@linux.intel.com>
 <CAHp75VcqKunkHYNdd287_F7APHwYr7K9QD2PVCkqBqJWG2_E-g@mail.gmail.com>
 <20180905173355.GE11368@linux.intel.com>
 <CAHp75Vc2SZUfRnBPZ9xJ_B=KJL7yK9hqRZiFOTswn0AzjnLD1A@mail.gmail.com>
 <20180906092100.GA27302@linux.intel.com>
 <CANiq72kpY1y2aPH+GMi8mWZdttfdYJ3wk0cvE_qVD97vdvTJbQ@mail.gmail.com>
 <5137f85388e26ea1ed46b34901b0f18540aee7cb.camel@perches.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5137f85388e26ea1ed46b34901b0f18540aee7cb.camel@perches.com>
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Thu, Sep 06, 2018 at 05:50:01PM -0700, Joe Perches wrote:
> On Thu, 2018-09-06 at 19:35 +0200, Miguel Ojeda wrote:
> > > Which one is right and why the kernel tree is polluted with C99-headers
> > > when they do not pass checkpatch.pl?
> 
> checkpatch ignores c99 headers since 2016.

Jarkko was referring to c99 comments for the SPDX license.  checkpatch
explicitly requires c-style comments for headers and assembly files as
dictated by Documentation/process/license-rules.rst.  

$ grep -r SPDX **/*.h | grep \/\/ | wc -l
665

$ grep -r SPDX **/*.S | grep \/\/ | wc -l
22

$ git show 9f3a89926d6df
commit 9f3a89926d6dfc30a4fd1bbcb92cc7b218d3786d
Author: Rob Herring <robh@kernel.org>
Date:   Tue Apr 10 16:33:13 2018 -0700

    checkpatch.pl: add SPDX license tag check

    Add SPDX license tag check based on the rules defined in
    Documentation/process/license-rules.rst.  To summarize, SPDX license
    tags should be on the 1st line (or 2nd line in scripts) using the
    appropriate comment style for the file type.

    Link: http://lkml.kernel.org/r/20180202154026.15298-1-robh@kernel.org
    Signed-off-by: Rob Herring <robh@kernel.org>
    Signed-off-by: Joe Perches <joe@perches.com>
    Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Acked-by: Philippe Ombredanne <pombredanne@nexb.com>
    Cc: Andy Whitcroft <apw@canonical.com>
    Cc: Joe Perches <joe@perches.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Igor Stoppa <igor.stoppa@huawei.com>
    Cc: Jonathan Corbet <corbet@lwn.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b464a4c3f863..0f022b56f117 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2257,6 +2257,8 @@ sub process {

        my $camelcase_file_seeded = 0;

+       my $checklicenseline = 1;
+
        sanitise_line_reset();
        my $line;
        foreach my $rawline (@rawlines) {
@@ -2448,6 +2450,7 @@ sub process {
                        } else {
                                $check = $check_orig;
                        }
+                       $checklicenseline = 1;
                        next;
                }

@@ -2911,6 +2914,30 @@ sub process {
                        }
                }

+# check for using SPDX license tag at beginning of files
+               if ($realline == $checklicenseline) {
+                       if ($rawline =~ /^[ \+]\s*\#\!\s*\//) {
+                               $checklicenseline = 2;
+                       } elsif ($rawline =~ /^\+/) {
+                               my $comment = "";
+                               if ($realfile =~ /\.(h|s|S)$/) {
+                                       $comment = '/*';
+                               } elsif ($realfile =~ /\.(c|dts|dtsi)$/) {
+                                       $comment = '//';
+                               } elsif (($checklicenseline == 2) || $realfile =~ /\.(sh|pl|py|awk|tc)$/) {
+                                       $comment = '#';
+                               } elsif ($realfile =~ /\.rst$/) {
+                                       $comment = '..';
+                               }
+
+                               if ($comment !~ /^$/ &&
+                                   $rawline !~ /^\+\Q$comment\E SPDX-License-Identifier: /) {
+                                       WARN("SPDX_LICENSE_TAG",
+                                            "Missing or malformed SPDX-License-Identifier tag in line $checklicenseline\n" . $herecurr);
+                               }
+                       }
+               }
+
 # check we are in a valid source file if not then ignore this hunk
                next if ($realfile !~ /\.(h|c|s|S|sh|dtsi|dts)$/);
