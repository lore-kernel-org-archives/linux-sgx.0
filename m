Return-Path: <SRS0=/5Ao=CE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A995FC433E1
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Aug 2020 20:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 840FB207DF
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Aug 2020 20:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgHZUPP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 26 Aug 2020 16:15:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:56548 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgHZUPO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 26 Aug 2020 16:15:14 -0400
IronPort-SDR: o6DrrMBRyOa5SXtC4HToImGF/FTEPhuBvwC4n7Pq2o47eXdyVA08W81+klqh4zwoc/Nv2Gi7tP
 zhOx4u97Tfaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9725"; a="217928321"
X-IronPort-AV: E=Sophos;i="5.76,356,1592895600"; 
   d="scan'208";a="217928321"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2020 13:15:12 -0700
IronPort-SDR: HAsOMWVpqFE1Y2KnVGr2Ul/cfmB7vYDvR+qmMPXgTcB7K/ShlwGewZOGxns3GRPJ/Vpb6QnqAr
 ekWTl4B2TzwA==
X-IronPort-AV: E=Sophos;i="5.76,356,1592895600"; 
   d="scan'208";a="295486246"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2020 13:15:12 -0700
Date:   Wed, 26 Aug 2020 13:15:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: Re: [RFC PATCH 2/4] x86/vdso: x86/sgx: Rework
 __vdso_sgx_enter_enclave() API
Message-ID: <20200826201511.GB21459@sjchrist-ice>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-3-sean.j.christopherson@intel.com>
 <2ddc5a5b-0929-b99f-41a0-06b3b53fcc8f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ddc5a5b-0929-b99f-41a0-06b3b53fcc8f@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 26, 2020 at 12:27:54PM -0700, Xing, Cedric wrote:
> On 8/17/2020 9:24 PM, Sean Christopherson wrote:
> > Rework __vdso_sgx_enter_enclave() to use a struct to hold the input and
> > output params.  In the new struct, add an opaque "user_data" that can be
> > used to pass context across the vDSO, and an explicit "exit_reason" to
> > avoid overloading the return value.
> > In order to pass additional parameters to the exit handler, the exinfo
> structure could be embedded in a user-defined structure while the handler
> could pick it up using "container_of" macro. IMO the original interface was
> neat and suffcient, and we are over-engineering it.

container_of/offsetof shenanigans were my original suggestion as well.
Nathaniel's argument is that using such tricks is less than pleasent in a
Rust environment.

https://lkml.kernel.org/r/CAOASepOFh-vOrNZEVDFrDSuHs+9GEzzpXUTG-fZMuyjWAkpRWw@mail.gmail.com

> > Moving the params into a struct will also make it less painful to use
> > dedicated exit reasons, and to support exiting on interrupts in future
> > patches.
> > 
> My apology for not following discussion lately. What did you mean by
> "dedicated exit reasons" and why was it "painful"? According to another
> thread, I guess we wouldn't have "exiting on interrupts".

Currently the vDSO returns -EFAULT if the enclave encounters an exception,
which is kludgy for two reasons:

 1. EFAULT traditionally means "bad address", whereas an exception could be
    a #UD in the enclave.

 2. Returning -EFAULT provides weird semantics as it implies the vDSO call
    failed, which is not the case.  The vDSO itself was successful, i.e. it
    did the requested EENTER/ERESUME operation, and should really return '0'.

The proposed solution for #1 is to define arbitrary return values to
differentiate between synchronous (EEXIT) exits and asynchronous exits due
to exceptions.  But that doesn't address #2, and gets especially awkward when
dealing with the call back return, which is also overloaded to use positive
return values for ENCLU leafs.

Passing a "run" struct makes it trivially easy to different the return value
of the vDSO function from the enclave exit reason, and to avoid collisions
with the return value from the userspace callback.
