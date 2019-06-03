Return-Path: <SRS0=nxNq=UC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE5FC04AB5
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 23:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F2D226329
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 23:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfFCXsu convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Jun 2019 19:48:50 -0400
Received: from mga03.intel.com ([134.134.136.65]:45303 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfFCXsu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 3 Jun 2019 19:48:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jun 2019 16:48:49 -0700
X-ExtLoop1: 1
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga001.fm.intel.com with ESMTP; 03 Jun 2019 16:48:48 -0700
Received: from orsmsx125.amr.corp.intel.com (10.22.240.125) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 3 Jun 2019 16:48:48 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX125.amr.corp.intel.com ([169.254.3.172]) with mapi id 14.03.0415.000;
 Mon, 3 Jun 2019 16:48:47 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: RE: [RFC PATCH 3/9] x86/sgx: Allow userspace to add multiple pages
 in single ioctl()
Thread-Topic: [RFC PATCH 3/9] x86/sgx: Allow userspace to add multiple pages
 in single ioctl()
Thread-Index: AQHVGAki7TYpY4ZsUk+m4jTej+khLaaK1z+AgAAGRQD//79uoA==
Date:   Mon, 3 Jun 2019 23:48:47 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654ED499@ORSMSX116.amr.corp.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-4-sean.j.christopherson@intel.com>
 <beb8ac7a-b580-8ff2-7467-fb2870fb8cf0@intel.com>
 <20190603203712.GI13384@linux.intel.com>
In-Reply-To: <20190603203712.GI13384@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNTAxNjYzMWQtZDY5OC00ZWI3LTk2OWEtOWJkZjNiZTQyOWEzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTUg1cmMzcysxSFhSSFhEb1Z5MGpja250Qzk1SnhVakRIOTFySFNaNXlkQUdaWVh0SmNSNEZMNHZGT3JrdnRubiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> -----Original Message-----
> From: Christopherson, Sean J
> Sent: Monday, June 03, 2019 1:37 PM
> To: Hansen, Dave <dave.hansen@intel.com>
> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>; Andy Lutomirski
> <luto@kernel.org>; Xing, Cedric <cedric.xing@intel.com>; Stephen Smalley
> <sds@tycho.nsa.gov>; James Morris <jmorris@namei.org>; Serge E . Hallyn
> <serge@hallyn.com>; LSM List <linux-security-module@vger.kernel.org>;
> Paul Moore <paul@paul-moore.com>; Eric Paris <eparis@parisplace.org>;
> selinux@vger.kernel.org; Jethro Beekman <jethro@fortanix.com>; Thomas
> Gleixner <tglx@linutronix.de>; Linus Torvalds <torvalds@linux-
> foundation.org>; LKML <linux-kernel@vger.kernel.org>; X86 ML
> <x86@kernel.org>; linux-sgx@vger.kernel.org; Andrew Morton <akpm@linux-
> foundation.org>; nhorman@redhat.com; npmccallum@redhat.com; Ayoun, Serge
> <serge.ayoun@intel.com>; Katz-zamir, Shay <shay.katz-zamir@intel.com>;
> Huang, Haitao <haitao.huang@intel.com>; Andy Shevchenko
> <andriy.shevchenko@linux.intel.com>; Svahn, Kai <kai.svahn@intel.com>;
> Borislav Petkov <bp@alien8.de>; Josh Triplett <josh@joshtriplett.org>;
> Huang, Kai <kai.huang@intel.com>; David Rientjes <rientjes@google.com>;
> Roberts, William C <william.c.roberts@intel.com>; Tricca, Philip B
> <philip.b.tricca@intel.com>
> Subject: Re: [RFC PATCH 3/9] x86/sgx: Allow userspace to add multiple
> pages in single ioctl()
> 
> On Mon, Jun 03, 2019 at 01:14:45PM -0700, Dave Hansen wrote:
> > On 5/31/19 4:31 PM, Sean Christopherson wrote:
> > > -struct sgx_enclave_add_page {
> > > +struct sgx_enclave_add_pages {
> > >  	__u64	addr;
> > >  	__u64	src;
> > >  	__u64	secinfo;
> > > +	__u32	nr_pages;
> > >  	__u16	mrmask;
> > >  } __attribute__((__packed__));
> >
> > IMNHO this follows a user interface anti-pattern: exposing page sizes
> > where not strictly required.
> >
> > Think of how this would look to an application if page size was
> > variable.  With this interface, they always need to scale their
> > operations by page size instead of just aligning it.
> 
> I briefly considered taking size in bytes, but I took a shortcut because
> EPC pages are architecturally defined to be 4k sized and aligned.  That
> being said, I don't necessarily disagree, especially if nr_pages isn't
> squeezed into a u32.
> 
> > BTW, why is nr_pages a u32?  Do we never envision a case where you can
> > add more than 4TB of memory to an enclave? ;)
> 
> Heh, fair enough.  IIRC, a while back someone posted about having
> problems building a 512gb enclave in a 92mb EPC...
> 
> How about this for the intermediate patch:
> 
> 	struct sgx_enclave_add_region {
> 		__u64	addr;
> 		__u64	src;
> 		__u64	size;
> 		__u64	secinfo;
> 		__u16	mrmask;
> 		__u16	reserved16;
> 		__u32	reserved;
> 	}
> 
> and with the flags field:
> 
> 	struct sgx_enclave_add_region {
> 		__u64	addr;
> 		__u64	src;
> 		__u64	size;
> 		__u64	secinfo;
> 		__u16	mrmask;
> 		__u16	flags;

What is "flags" here?

> 		__u32	reserved;
> 	}
