Return-Path: <SRS0=6XgF=UE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F54C28CC5
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 11:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64DB62075B
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 11:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfFELKw convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 07:10:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:43361 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbfFELKv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Jun 2019 07:10:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 04:10:50 -0700
X-ExtLoop1: 1
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga007.jf.intel.com with ESMTP; 05 Jun 2019 04:10:49 -0700
Received: from fmsmsx112.amr.corp.intel.com (10.18.116.6) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 5 Jun 2019 04:10:49 -0700
Received: from HASMSX109.ger.corp.intel.com (10.184.198.21) by
 FMSMSX112.amr.corp.intel.com (10.18.116.6) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 5 Jun 2019 04:10:48 -0700
Received: from hasmsx108.ger.corp.intel.com ([169.254.9.66]) by
 hasmsx109.ger.corp.intel.com ([169.254.3.53]) with mapi id 14.03.0415.000;
 Wed, 5 Jun 2019 14:10:46 +0300
From:   "Ayoun, Serge" <serge.ayoun@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     Andy Lutomirski <luto@kernel.org>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: RE: [RFC PATCH 6/9] x86/sgx: Require userspace to provide allowed
 prots to ADD_PAGES
Thread-Topic: [RFC PATCH 6/9] x86/sgx: Require userspace to provide allowed
 prots to ADD_PAGES
Thread-Index: AQHVGAkkmG7HFOrZhE6WGVzca6YfCqaM7RtA
Date:   Wed, 5 Jun 2019 11:10:44 +0000
Message-ID: <88B7642769729B409B4A93D7C5E0C5E7C64475FB@hasmsx108.ger.corp.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-7-sean.j.christopherson@intel.com>
In-Reply-To: <20190531233159.30992-7-sean.j.christopherson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNWY0NjBiOTctZTkxMy00Nzg1LTk4OTgtMmQ1NTAwYTZmZDU0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZndTM0lNaWlzSTNSU3hoc3M5TlNjc2xyXC94cVBuaTFseGdTQ01SeUYzQXlUMHBnOHJkQjhTMGdERTYzZ2tFdkQifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> From: Christopherson, Sean J
> Sent: Saturday, June 01, 2019 02:32
> 
>  /**
>   * struct sgx_enclave_add_pages - parameter structure for the
>   *                                %SGX_IOC_ENCLAVE_ADD_PAGES ioctl
> @@ -39,6 +44,7 @@ struct sgx_enclave_create  {
>   * @secinfo:	address for the SECINFO data (common to all pages)
>   * @nr_pages:	number of pages (must be virtually contiguous)
>   * @mrmask:	bitmask for the measured 256 byte chunks (common to all
> pages)
> + * @flags:	flags, e.g. SGX_ALLOW_{READ,WRITE,EXEC} (common to all
> pages)
>   */
>  struct sgx_enclave_add_pages {
>  	__u64	addr;
> @@ -46,7 +52,8 @@ struct sgx_enclave_add_pages {
>  	__u64	secinfo;
>  	__u32	nr_pages;
>  	__u16	mrmask;
> -} __attribute__((__packed__));
> +	__u16	flags;
> +};

You are adding a flags member. The secinfo structure has already a flags member in it.
Why do you need both - they are both coming from user mode. What kind of scenario would
require having different values. Seems confusing.

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

