Return-Path: <SRS0=Kf/c=D2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89295C433E7
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 20:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42440223EA
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 20:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgJSUsy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Oct 2020 16:48:54 -0400
Received: from mga18.intel.com ([134.134.136.126]:59815 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbgJSUsy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Oct 2020 16:48:54 -0400
IronPort-SDR: +jNfbTBwyn6dzbb6osDG2vHRlxfB9aPI5dUNxOzMAPfvNfecOzgeu+m0Cw73eX/arbmydgKo23
 Zfg9eJXPReYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="154888477"
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="154888477"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 13:48:51 -0700
IronPort-SDR: cm1QVCVsRcaS10+hBK6utHuUhevmVBlc4cJKrj49U6pb0dwq8QReRCEBLlkySAKqOjkn0Y036f
 F+utmTuTbIow==
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="315785615"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 13:48:51 -0700
Date:   Mon, 19 Oct 2020 13:48:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v39 12/24] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
Message-ID: <20201019204848.GB23072@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-13-jarkko.sakkinen@linux.intel.com>
 <5f194bf0-ced1-66e1-b6a2-503741a3e7f1@intel.com>
 <20201018042633.GI68722@linux.intel.com>
 <f6fe37ee-7b5c-15b6-6823-2500582e7921@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6fe37ee-7b5c-15b6-6823-2500582e7921@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 19, 2020 at 01:21:09PM -0700, Dave Hansen wrote:
> On 10/17/20 9:26 PM, Jarkko Sakkinen wrote:
> >>> +long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> >>> +{
> >>> +	struct sgx_encl *encl = filep->private_data;
> >>> +	int ret, encl_flags;
> >>> +
> >>> +	encl_flags = atomic_fetch_or(SGX_ENCL_IOCTL, &encl->flags);
> >>> +	if (encl_flags & SGX_ENCL_IOCTL)
> >>> +		return -EBUSY;
> >>
> >> Is the SGX_ENCL_IOCTL bit essentially just a lock to single-thread
> >> ioctl()s?  Should we name it as such?
> > 
> > Yes. It makes the concurrency overally easier if we can assume that
> > only a single ioctl is in progress. There is no good reason to do
> > them in parallel.
> > 
> > E.g. when you add pages you want to do that serially because the
> > order changes the MRENCLAVE.
> 
> There are also hardware concurrency requirements, right?  A bunch of the
> SGX functions seem not not even support being called in parallel.

Yes, and the driver, even when "holding" SGX_ENCL_IOCTL, takes encl->lock
when executing an ENCLS leaf.  The separate IOCTL flag avoids complications
with reclaim, specifically it allows the ioctls to initiate reclaim without
hitting a deadlock.

Reclaim needs to take encl->lock, e.g. to do ENCLS[EBLOCK], and reclaim is by
default initiated during allocation if there are no pages available.  I.e. if
an ioctl() simply held encl->lock, it would deadlock in the scenario where it
triggered reclaim on the current enclave.

In other words, the flag is necessary even if it weren't being used a lock
primitive, e.g. it'd still need to exist even if encl->lock were taken to set
and check the flag.  The atomic shenanigans were added as an optimization to
allow reclaim in parallel with the bulk of the ioctl flows, and partly because
using atomic_fetch_or() avoided having to drop encl->lock in an error flow,
i.e. yielded less code.

> > So should I rename it as SGX_ENCL_IOCTL_LOCKED?
> 
> I'd rather not see hand-rolled locking primitives frankly.

IOCTL_IN_PROGRESS would be my vote if we want a more descriptive name.
