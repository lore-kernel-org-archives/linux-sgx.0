Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3B2C3A5A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 11:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA8DD233FD
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 11:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732911AbfHVLdp convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 07:33:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:33795 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731987AbfHVLdo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 07:33:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 04:33:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,416,1559545200"; 
   d="scan'208";a="181357148"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga003.jf.intel.com with ESMTP; 22 Aug 2019 04:33:42 -0700
Received: from fmsmsx119.amr.corp.intel.com (10.18.124.207) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 22 Aug 2019 04:33:39 -0700
Received: from hasmsx114.ger.corp.intel.com (10.184.198.65) by
 FMSMSX119.amr.corp.intel.com (10.18.124.207) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 22 Aug 2019 04:33:39 -0700
Received: from hasmsx108.ger.corp.intel.com ([169.254.9.203]) by
 HASMSX114.ger.corp.intel.com ([169.254.14.15]) with mapi id 14.03.0439.000;
 Thu, 22 Aug 2019 14:33:36 +0300
From:   "Ayoun, Serge" <serge.ayoun@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Subject: RE: [PATCH 4/5] x86/sgx: Validate TCS permssions in
 sgx_validate_secinfo()
Thread-Topic: [PATCH 4/5] x86/sgx: Validate TCS permssions in
 sgx_validate_secinfo()
Thread-Index: AQHVWFCvFMHTkYfGZE23NSwbiGthjqcHCJYg
Date:   Thu, 22 Aug 2019 11:33:35 +0000
Message-ID: <88B7642769729B409B4A93D7C5E0C5E7C661E7A7@hasmsx108.ger.corp.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
 <20190819152544.7296-5-jarkko.sakkinen@linux.intel.com>
 <20190821184544.ii37h7hhxjiocbb4@linux.intel.com>
In-Reply-To: <20190821184544.ii37h7hhxjiocbb4@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZDhiMWIyNzctOWNjMy00YWU1LWI1NGUtMGY4ZGRmMmQ4ZDU0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiWVRqeDFPMTRvNjlRbkJBR3VMNFI1M1MrVXBjckgrXC8wNXBFNXdPRDZlejJWbDBGZzMxTzd1R1YxckJqbFhzSTMifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> From: linux-sgx-owner@vger.kernel.org <linux-sgx-owner@vger.kernel.org>
> On Behalf Of Jarkko Sakkinen
> Sent: Wednesday, August 21, 2019 21:46
> To: linux-sgx@vger.kernel.org
> Cc: Christopherson, Sean J <sean.j.christopherson@intel.com>
> Subject: Re: [PATCH 4/5] x86/sgx: Validate TCS permssions in
> sgx_validate_secinfo()
> 
> On Mon, Aug 19, 2019 at 06:25:43PM +0300, Jarkko Sakkinen wrote:
> > The validation of TCS permissions was missing from
> > sgx_validate_secinfo(). This patch adds the validation.
> >
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > index 99b1b9776c3a..2415dcb20a6e 100644
> > --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > @@ -423,6 +423,12 @@ static int sgx_validate_secinfo(struct sgx_secinfo
> *secinfo)
> >  	if ((perm & SGX_SECINFO_W) && !(perm & SGX_SECINFO_R))
> >  		return -EINVAL;
> >
> > +	/* CPU will silently overwrite the permissions as zero, which means
> > +	 * that we need to validate it ourselves.
> > +	 */
> > +	if (page_type == SGX_SECINFO_TCS && perm)
> > +		return -EINVAL;
> > +
> >  	if (secinfo->flags & SGX_SECINFO_RESERVED_MASK)
> >  		return -EINVAL;
> >
> > --
> > 2.20.1
> >
> 
> OK, just found out that this patch did not end up to my test image and
> causes a regression.
> 
> I think this should be fixed in sgx_encl_may_map() by having the
> following special case for TCS (in addition to the change in this
> patch of course):
> 
> 1. Check if we encounter a TCS page.
> 2. If yes, we evaluate RW for the VM flags.
> 

Also replying to Sean.
Sean is right that never mind the value in secsinfo->flags, HW will reset RWX
For TCS pages.
So basically you may not enforce and and could not check those but... The signature depends
On those flags, so if you put a non-zero flag value, eadd will pass but if you
compute the signature according to this non zero value then you will have
a delta between ur signature and HW's signature: einit will fail.
So this is tricky and more a usability issue.
I vote for checking the flag is zeroed.
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

