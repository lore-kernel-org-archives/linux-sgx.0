Message-ID: <5137f85388e26ea1ed46b34901b0f18540aee7cb.camel@perches.com>
Subject: Re: [PATCH v13 11/13] platform/x86: Intel SGX driver
From: Joe Perches <joe@perches.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>
CC: Andy Shevchenko <andy.shevchenko@gmail.com>, "maintainer:X86 ARCHITECTURE
 (32-BIT AND 64-BIT)" <x86@kernel.org>, Platform Driver
	<platform-driver-x86@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	<serge.ayoun@intel.com>, <shay.katz-zamir@intel.com>, "Siddha, Suresh B"
	<suresh.b.siddha@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Darren Hart
	<dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Herbert Xu
	<herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@google.com>, "Linux
 Kernel Mailing List" <linux-kernel@vger.kernel.org>
Date: Thu, 6 Sep 2018 17:50:01 -0700
In-Reply-To: <CANiq72kpY1y2aPH+GMi8mWZdttfdYJ3wk0cvE_qVD97vdvTJbQ@mail.gmail.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
         <20180827185507.17087-12-jarkko.sakkinen@linux.intel.com>
         <CAHp75VcqKunkHYNdd287_F7APHwYr7K9QD2PVCkqBqJWG2_E-g@mail.gmail.com>
         <20180905173355.GE11368@linux.intel.com>
         <CAHp75Vc2SZUfRnBPZ9xJ_B=KJL7yK9hqRZiFOTswn0AzjnLD1A@mail.gmail.com>
         <20180906092100.GA27302@linux.intel.com>
         <CANiq72kpY1y2aPH+GMi8mWZdttfdYJ3wk0cvE_qVD97vdvTJbQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Thu, 2018-09-06 at 19:35 +0200, Miguel Ojeda wrote:
> > Which one is right and why the kernel tree is polluted with C99-headers
> > when they do not pass checkpatch.pl?

checkpatch ignores c99 headers since 2016.

$ git log --stat -p -1 dadf680de3c2eb4cba9840619991eda0cfe98778
commit dadf680de3c2eb4cba9840619991eda0cfe98778
Author: Joe Perches <joe@perches.com>
Date:   Tue Aug 2 14:04:33 2016 -0700

    checkpatch: allow c99 style // comments
    
    Sanitise the lines that contain c99 comments so that the error doesn't
    get emitted.
    
    Link: http://lkml.kernel.org/r/d4d22c34ad7bcc1bceb52f0742f76b7a6d585235.1468368420.git.joe@perches.com
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a4476b61e93f..79273003d5e7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -55,6 +55,7 @@ my $spelling_file = "$D/spelling.txt";
 my $codespell = 0;
 my $codespellfile = "/usr/share/codespell/dictionary.txt";
 my $color = 1;
+my $allow_c99_comments = 1;
 
 sub help {
        my ($exitcode) = @_;
@@ -1144,6 +1145,11 @@ sub sanitise_line {
                $res =~ s@(\#\s*(?:error|warning)\s+).*@$1$clean@;
        }
 
+       if ($allow_c99_comments && $res =~ m@(//.*$)@) {
+               my $match = $1;
+               $res =~ s/\Q$match\E/"$;" x length($match)/e;
+       }
+
        return $res;
 }
