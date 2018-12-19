Return-Path: <SRS0=HOZE=O4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CFEC43387
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 07:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 123D02184C
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 07:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbeLSH6i (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Dec 2018 02:58:38 -0500
Received: from mga12.intel.com ([192.55.52.136]:49100 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbeLSH6i (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Dec 2018 02:58:38 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2018 23:58:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,371,1539673200"; 
   d="h'?scan'208";a="119602633"
Received: from quwen-mobl.ccr.corp.intel.com ([10.249.254.215])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Dec 2018 23:58:29 -0800
Message-ID: <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
Subject: x86/sgx: uapi change proposal
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        sean.j.christopherson@intel.com
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Date:   Wed, 19 Dec 2018 09:58:26 +0200
In-Reply-To: <20181214215729.4221-1-sean.j.christopherson@intel.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: multipart/mixed; boundary="=-Kw50GBTEA/+nFrI57M4Y"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


--=-Kw50GBTEA/+nFrI57M4Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

I have pretty much figured out how to change the driver implementation
from VMA based to file based. Most of the code in the driver can be
reused with not that enormous changes. I think it is a clue that the
architecture is somewhat right because changing the driver this
radically does not seem to require any changes to the core.

Using anon inode is the right choice because it is more robust interface
to be able to create multiple enclaves.

The only remaining open that I have when it comes to implementing this
is the backing storage. From API perspective the most robust choice
would be to revert to use shmem file. It would be easy then to create a
complete construction flow without any dependencies to mm_struct.

I do recognize the issue with accounting but to which process the
backing storage should be accounted anyway in this new paradigm.

I've attached the new uapi header to this email that I'm going forward
with.

/Jarkko

--=-Kw50GBTEA/+nFrI57M4Y
Content-Disposition: attachment; filename="sgx.h"
Content-Type: text/x-chdr; name="sgx.h"; charset="UTF-8"
Content-Transfer-Encoding: base64

LyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IChHUEwtMi4wIE9SIEJTRC0zLUNsYXVzZSkgKi8K
LyoqCiAqIENvcHlyaWdodChjKSAyMDE2LTE4IEludGVsIENvcnBvcmF0aW9uLgogKi8KI2lmbmRl
ZiBfVUFQSV9BU01fWDg2X1NHWF9ICiNkZWZpbmUgX1VBUElfQVNNX1g4Nl9TR1hfSAoKI2luY2x1
ZGUgPGxpbnV4L3R5cGVzLmg+CiNpbmNsdWRlIDxsaW51eC9pb2N0bC5oPgoKI2RlZmluZSBTR1hf
TUFHSUMgMHhBNAoKI2RlZmluZSBTR1hfSU9DX0VOQ0xBVkVfQ1JFQVRFIFwKCV9JT1coU0dYX01B
R0lDLCAweDAwLCBzdHJ1Y3Qgc2d4X2VuY2xhdmVfY3JlYXRlKQojZGVmaW5lIFNHWF9JT0NfRU5D
TEFWRV9BRERfUEFHRSBcCglfSU9XKFNHWF9NQUdJQywgMHgwMSwgc3RydWN0IHNneF9lbmNsYXZl
X2FkZF9wYWdlKQojZGVmaW5lIFNHWF9JT0NfRU5DTEFWRV9JTklUIFwKCV9JT1coU0dYX01BR0lD
LCAweDAyLCBzdHJ1Y3Qgc2d4X2VuY2xhdmVfaW5pdCkKI2RlZmluZSBTR1hfSU9DX0VOQ0xBVkVf
U0VUX0FUVFJJQlVURSBcCglfSU9XKFNHWF9NQUdJQywgMHgwMywgc3RydWN0IHNneF9lbmNsYXZl
X3NldF9hdHRyaWJ1dGUpCgovKiBJT0NUTCByZXR1cm4gdmFsdWVzICovCiNkZWZpbmUgU0dYX1BP
V0VSX0xPU1RfRU5DTEFWRQkJMHg0MDAwMDAwMAoKLyoqCiAqIHN0cnVjdCBzZ3hfZW5jbGF2ZV9j
cmVhdGUgLSBwYXJhbWV0ZXIgc3RydWN0dXJlIGZvciB0aGUKICogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICVTR1hfSU9DX0VOQ0xBVkVfQ1JFQVRFIGlvY3RsCiAqIEBzcmM6CWFkZHJlc3Mg
Zm9yIHRoZSBTRUNTIHBhZ2UgZGF0YQogKiBAZW5jbGF2ZV9mZDoJZmlsZSBoYW5kbGUgdG8gdGhl
IGVuY2xhdmUgYWRkcmVzcyBzcGFjZSAob3V0KQogKi8Kc3RydWN0IHNneF9lbmNsYXZlX2NyZWF0
ZSAgewoJX191NjQJc3JjOwoJX191NjQJZW5jbGF2ZV9mZDsKfTsKCi8qKgogKiBzdHJ1Y3Qgc2d4
X2VuY2xhdmVfYWRkX3BhZ2UgLSBwYXJhbWV0ZXIgc3RydWN0dXJlIGZvciB0aGUKICogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgJVNHWF9JT0NfRU5DTEFWRV9BRERfUEFHRSBpb2N0bAog
KiBAZWNsYXZlX2ZkOglmaWxlIGhhbmRsZSB0byB0aGUgZW5jbGF2ZSBhZGRyZXNzIHNwYWNlCiAq
IEBzcmM6CWFkZHJlc3MgZm9yIHRoZSBwYWdlIGRhdGEKICogQHNlY2luZm86CWFkZHJlc3MgZm9y
IHRoZSBTRUNJTkZPIGRhdGEKICogQG1ybWFzazoJYml0bWFzayBmb3IgdGhlIG1lYXN1cmVkIDI1
NiBieXRlIGNodW5rcwogKi8Kc3RydWN0IHNneF9lbmNsYXZlX2FkZF9wYWdlIHsKCV9fdTY0CWVu
Y2xhdmVfZmQ7CglfX3U2NAlzcmM7CglfX3U2NAlzZWNpbmZvOwoJX191MTYJbXJtYXNrOwp9IF9f
YXR0cmlidXRlX18oKF9fcGFja2VkX18pKTsKCgovKioKICogc3RydWN0IHNneF9lbmNsYXZlX2lu
aXQgLSBwYXJhbWV0ZXIgc3RydWN0dXJlIGZvciB0aGUKICogICAgICAgICAgICAgICAgICAgICAg
ICAgICAlU0dYX0lPQ19FTkNMQVZFX0lOSVQgaW9jdGwKICogQGVjbGF2ZV9mZDoJZmlsZSBoYW5k
bGUgdG8gdGhlIGVuY2xhdmUgYWRkcmVzcyBzcGFjZQogKiBAc2lnc3RydWN0OglhZGRyZXNzIGZv
ciB0aGUgU0lHU1RSVUNUIGRhdGEKICovCnN0cnVjdCBzZ3hfZW5jbGF2ZV9pbml0IHsKCV9fdTY0
CWVuY2xhdmVfZmQ7CglfX3U2NAlzaWdzdHJ1Y3Q7Cn07CgovKioKICogc3RydWN0IHNneF9lbmNs
YXZlX3NldF9hdHRyaWJ1dGUgLSBwYXJhbWV0ZXIgc3RydWN0dXJlIGZvciB0aGUKICoJCQkJICAg
ICAgJVNHWF9JT0NfRU5DTEFWRV9JTklUIGlvY3RsCiAqIEBhZGRyOgkJYWRkcmVzcyB3aXRoaW4g
dGhlIEVMUkFOR0UKICogQGVjbGF2ZV9mZDoJCWZpbGUgaGFuZGxlIHRvIHRoZSBlbmNsYXZlIGFk
ZHJlc3Mgc3BhY2UKICogQGF0dHJpYnV0ZV9mZDoJZmlsZSBoYW5kbGUgb2YgdGhlIGF0dHJpYnV0
ZSBmaWxlIGluIHRoZSBzZWN1cml0eWZzCiAqLwpzdHJ1Y3Qgc2d4X2VuY2xhdmVfc2V0X2F0dHJp
YnV0ZSB7CglfX3U2NAllbmNsYXZlX2ZkOwoJX191NjQJYXR0cmlidXRlX2ZkOwp9OwoKI2VuZGlm
IC8qIF9VQVBJX0FTTV9YODZfU0dYX0ggKi8K


--=-Kw50GBTEA/+nFrI57M4Y--

