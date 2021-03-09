Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E573C433DB
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Mar 2021 00:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B01C64F7C
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Mar 2021 00:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhCIAkq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Mar 2021 19:40:46 -0500
Received: from mga12.intel.com ([192.55.52.136]:23575 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230301AbhCIAk1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 8 Mar 2021 19:40:27 -0500
IronPort-SDR: r0t1ehaWpEdcpsapiGs8l4OfqB+Rzf3AXpv2eQiYney2qPUIBiDeUeW8fzS6+0zFc07Eq5qgPz
 HrYFDbEVjuOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="167400567"
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="167400567"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 16:40:26 -0800
IronPort-SDR: 6gNcOCvhJki5z5np+3Wy3sRHRjCFuYYBCFIX5zuweeJNHM9hXC4/zI/I6CR1b8sJW5TNG+yKn0
 VqrrPISAcxMA==
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="386038115"
Received: from hamidadx-mobl.amr.corp.intel.com (HELO [10.209.33.54]) ([10.209.33.54])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 16:40:26 -0800
Subject: SGX Performance Creep
To:     "Vij, Mona" <mona.vij@intel.com>,
        "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        "Kumar, Deepak1" <deepak1.kumar@intel.com>,
        "Helm, Kent" <kent.helm@intel.com>,
        "Narjala, Ranjit S" <ranjit.s.narjala@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Mathew, Shama" <shama.mathew@intel.com>,
        "Hossain, Md Iqbal" <md.iqbal.hossain@intel.com>,
        "Saffores, Ryan D" <ryan.d.saffores@intel.com>,
        "Jaramillo, Alex V" <alex.v.jaramillo@intel.com>,
        "Kuvaiskii, Dmitrii" <dmitrii.kuvaiskii@intel.com>,
        "Mahalingam, Ganesh" <ganesh.mahalingam@intel.com>
Cc:     "Sterrett, Craig" <craig.sterrett@intel.com>,
        "Macieira, Thiago" <thiago.macieira@intel.com>,
        "Salunke, Manoj" <manoj.salunke@intel.com>,
        "Gandhi, Jinen" <jinen.gandhi@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
References: <BYAPR11MB274479307F08C6AE305FB9A8F2BA9@BYAPR11MB2744.namprd11.prod.outlook.com>
 <MWHPR11MB19048655E5942E21F4D78983DA819@MWHPR11MB1904.namprd11.prod.outlook.com>
 <edb58aeb-6f6a-236c-046d-b692377cc550@intel.com>
 <BYAPR11MB274441F17146490289EED9A3F2819@BYAPR11MB2744.namprd11.prod.outlook.com>
 <DM6PR11MB4723CB5D0DF41F38FB59154399819@DM6PR11MB4723.namprd11.prod.outlook.com>
 <d5d851d7-ebb0-df51-2684-b916f2b47432@intel.com>
 <BYAPR11MB2744D84CAB45A321D7B83389F2819@BYAPR11MB2744.namprd11.prod.outlook.com>
 <BYAPR11MB2744212BCA03E628DA29D2C8F2809@BYAPR11MB2744.namprd11.prod.outlook.com>
 <MW3PR11MB468192CCAC4C2B12DFF7EC99F9809@MW3PR11MB4681.namprd11.prod.outlook.com>
 <MW3PR11MB46012C10D9526DE48641512FB6809@MW3PR11MB4601.namprd11.prod.outlook.com>
 <MW3PR11MB47295620E26A7612D81FCB2899809@MW3PR11MB4729.namprd11.prod.outlook.com>
 <b9bb309e2385537e02bac93ad29d43b8b86e5143.camel@intel.com>
 <MW3PR11MB47295461B3E28FEEA28AE8A1999F9@MW3PR11MB4729.namprd11.prod.outlook.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <990a55e9-5160-c2ae-08ab-7e1d277bd310@intel.com>
Date:   Mon, 8 Mar 2021 16:40:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <MW3PR11MB47295461B3E28FEEA28AE8A1999F9@MW3PR11MB4729.namprd11.prod.outlook.com>
Content-Type: multipart/mixed;
 boundary="------------6FB37D7EEFB111786F022075"
Content-Language: en-US
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This is a multi-part message in MIME format.
--------------6FB37D7EEFB111786F022075
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

I got my hands on a NUC7CJYH, which is the first piece of functional
Flexible Launch Control hardware I've actually laid my hands on.

I went looking for any "performance creep".  I tried a very simple test:
Create and run an enclave that touches a 64MB statically-allocated
buffer.  (The patch to the kernel selftest to do this is attached).

tl;dr: I'm not seeing any meaningful change in runtimes, even after
running and tearing down the enclave for 6-7 hours.

I'm running the selftest like this, creating a log file with /usr/bin/time:

NOW=$(date +%s); make && while true; do /usr/bin/time ./test_sgx >>
$NOW.log 2>> $NOW.timelog || break; done

This lets me do a quick and dirty histogram of the runtimes.  Note that
there's a single, nice peak.  It's not "smeared" like I would expect
from slowly-degrading run times.

$ cat 1615229976.timelog  | grep elapsed | awk '{print $1}' | sort | uniq -c
      4 2.08user
     14 2.09user
    106 2.10user
    403 2.11user
   1055 2.12user
   1518 2.13user
   1268 2.14user
    726 2.15user
    302 2.16user
     96 2.17user
     23 2.18user
      8 2.19user
      1 2.20user

I'll run for another day or two and see if anything interesting shows
up.  But, for now, nothing interesting is happening.  Whatever folks are
seeing, it doesn't seem to be present on my little simple test case, or
this Atom-based hardware.

The kernel is: stock 5.12.0-rc2.
The CPU is: Intel(R) Celeron(R) J4005 CPU @ 2.00GHz


--------------6FB37D7EEFB111786F022075
Content-Type: text/x-patch; charset=UTF-8;
 name="64mb-enclave.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="64mb-enclave.patch"

diff --git a/tools/testing/selftests/sgx/test_encl.c b/tools/testing/self=
tests/sgx/test_encl.c
index cf25b5dc1e03..dd45a72a1b42 100644
--- a/tools/testing/selftests/sgx/test_encl.c
+++ b/tools/testing/selftests/sgx/test_encl.c
@@ -14,7 +14,21 @@ static void *memcpy(void *dest, const void *src, size_=
t n)
 	return dest;
 }
=20
+#define DATA_LEN (64 * 1<<20)
+static unsigned char data[DATA_LEN] =3D { 0x12 };
+
 void encl_body(void *rdi, void *rsi)
 {
+	int i;
+	int j;
+	int len =3D DATA_LEN;
+	int loops =3D 2;
+
+	for (j =3D 0; j < loops; j++) {
+		for (i =3D 0; i < len; i++) {
+			data[i] =3D (unsigned long)rdi;
+		}
+	}
+
 	memcpy(rsi, rdi, 8);
 }

--------------6FB37D7EEFB111786F022075--
