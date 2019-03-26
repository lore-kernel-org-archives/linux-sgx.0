Return-Path: <SRS0=OPzR=R5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137D0C43381
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 21:11:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E021B20823
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 21:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732128AbfCZVLU convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Mar 2019 17:11:20 -0400
Received: from mga17.intel.com ([192.55.52.151]:57921 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732118AbfCZVLU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 26 Mar 2019 17:11:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Mar 2019 14:11:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,274,1549958400"; 
   d="scan'208";a="158640313"
Received: from pgsmsx103.gar.corp.intel.com ([10.221.44.82])
  by fmsmga001.fm.intel.com with ESMTP; 26 Mar 2019 14:11:16 -0700
Received: from pgsmsx112.gar.corp.intel.com ([169.254.3.114]) by
 PGSMSX103.gar.corp.intel.com ([169.254.2.210]) with mapi id 14.03.0415.000;
 Wed, 27 Mar 2019 05:11:15 +0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
CC:     "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Svahn, Kai" <kai.svahn@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>
Subject: RE: [PATCH v19,RESEND 16/27] x86/sgx: Add the Linux SGX Enclave
 Driver
Thread-Topic: [PATCH v19,RESEND 16/27] x86/sgx: Add the Linux SGX Enclave
 Driver
Thread-Index: AQHU3zlqJyshVndaUUiNLGXmU0HMwKYdUroAgAALCICAACVqAIAA7wlA
Date:   Tue, 26 Mar 2019 21:11:14 +0000
Message-ID: <105F7BF4D0229846AF094488D65A0989356F2FAD@PGSMSX112.gar.corp.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-17-jarkko.sakkinen@linux.intel.com>
 <1553601688.17255.12.camel@intel.com>
 <alpine.DEB.2.21.1903261340030.1789@nanos.tec.linutronix.de>
 <20190326145452.GD3757@linux.intel.com>
In-Reply-To: <20190326145452.GD3757@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMWE2YTA2ZTUtNGNlZi00ZThmLWI1ODMtNGMxN2E0MjRmMWYyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiM1wvS3REMlV5TkZvNnZqUWhLb2RXUzRTV2Q4OXNPN05qb1wvT2R6OE1xN3p1TzFka0pzRkwxVDdscndyeFh1eW1GIn0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> On Tue, Mar 26, 2019 at 01:40:57PM +0100, Thomas Gleixner wrote:
> > On Tue, 26 Mar 2019, Huang, Kai wrote:
> > > On Wed, 2019-03-20 at 18:21 +0200, Jarkko Sakkinen wrote:
> > > >  13 files changed, 1657 insertions(+), 2 deletions(-)  create mode
> > > > 100644 arch/x86/include/uapi/asm/sgx.h  create mode 100644
> > > > arch/x86/kernel/cpu/sgx/driver/Makefile
> > > >  create mode 100644 arch/x86/kernel/cpu/sgx/driver/driver.h
> > > >  create mode 100644 arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > > >  create mode 100644 arch/x86/kernel/cpu/sgx/driver/main.c
> > > >  create mode 100644 arch/x86/kernel/cpu/sgx/encl.c  create mode
> > > > 100644 arch/x86/kernel/cpu/sgx/encl.h
> > >
> > > Shouldn't the driver be located somewhere under drivers/, but not under
> arch/x86?
> > >
> > > I don't think x86 maintainers should have the burden to review every
> > > code change made to SGX driver?
> >
> > I rather prefer to have it in x86. Why? Because driver code has a
> > tendency to get under the radar.
> 
> And having everything under arch/x86 will likely reduce the maintenance
> burden for everyone:
> 
>    - Doesn't require taking changes through multiple trees or coordinating
>      acks from multiple maintainers.
> 
>    - Significantly reduces the number of functions, macros, structs and
>      variables that needs to be exposed in asm/sgx.h (actually eliminates
>      it entirely at this point) which allows for sane code organization as
>      opposed to dumping everything in one big header.
> 
>    - Mostly avoids bikeshedding over whether something is architectural
>      or belongs in the so called driver.

Sure. Thanks.

Thanks,
-Kai
