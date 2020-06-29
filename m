Return-Path: <SRS0=HDiP=AK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CDBCC433DF
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Jun 2020 18:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 185CB204EC
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Jun 2020 18:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbgF2S7O (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 29 Jun 2020 14:59:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:65096 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730167AbgF2S6y (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 29 Jun 2020 14:58:54 -0400
IronPort-SDR: RWeeJ/8RlA8iam6h8rbkXQySlJPKg8Z8etXIA2PTHkj4OQbn5OXZrrwy1WPNeaYMZIpLnY12r3
 SoN2lGVZg+wg==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="147540174"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="147540174"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 08:27:19 -0700
IronPort-SDR: rGBMpfACiG1z4qkmaDQmtluftmaItl/SFgyVE8IlcTxjEYsTQkMzUpPHkLlLoyg+bUyRjEZRro
 RXKZLVmhfq9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="318245592"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga007.jf.intel.com with ESMTP; 29 Jun 2020 08:27:19 -0700
Date:   Mon, 29 Jun 2020 08:27:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20200629152718.GA12312@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200627174335.GC15585@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200627174335.GC15585@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Jun 27, 2020 at 07:43:35PM +0200, Borislav Petkov wrote:
> On Thu, Jun 18, 2020 at 01:08:33AM +0300, Jarkko Sakkinen wrote:
> > +static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
> > +			 void *token)
> > +{
> > +	u64 mrsigner[4];
> > +	int ret;
> > +	int i;
> > +	int j;
> > +
> > +	/* Check that the required attributes have been authorized. */
> > +	if (encl->secs_attributes & ~encl->allowed_attributes)
> > +		return -EACCES;
> > +
> > +	ret = sgx_get_key_hash(sigstruct->modulus, mrsigner);
> > +	if (ret)
> > +		return ret;
> > +
> > +	mutex_lock(&encl->lock);
> > +
> > +	if (atomic_read(&encl->flags) & SGX_ENCL_INITIALIZED) {
> > +		ret = -EFAULT;
> > +		goto err_out;
> > +	}
> 
> That test should be the first thing this function or its caller does.

Hmm, I was going to say that SGX_ENCL_INITIALIZED can't be checked until
encl->lock is held, but that's not true for this path as mutual exclusion
is provided by the SGX_ENCL_IOCTL flag.  So yeah, this can be checked at
the same time as SGX_ENCL_CREATED in sgx_ioc_enclave_init().

> > +	for (i = 0; i < SGX_EINIT_SLEEP_COUNT; i++) {
> > +		for (j = 0; j < SGX_EINIT_SPIN_COUNT; j++) {
> 
> Ew, what's that double-loop for?
> 
> It tries to init an enclave a bunch of times. Why does it need to init
> more than once?

ENCLS[EINIT] is interruptible because it has such a high latency, e.g. 50k+
cycles on success.  If an IRQ/NMI/SMI becomes pending, EINIT may fail with
SGX_UNMASKED_EVENT so that the event can be serviced.

The idea behind the double loop is to try EINIT in a tight loop, then back
off and sleep for a while before retrying that tight inner loop.

> > +			ret = sgx_einit(sigstruct, token, encl->secs.epc_page,
> > +					mrsigner);
> > +			if (ret == SGX_UNMASKED_EVENT)
> > +				continue;
> > +			else
> > +				break;
> > +		}
> > +
> > +		if (ret != SGX_UNMASKED_EVENT)
> > +			break;
> > +
> > +		msleep_interruptible(SGX_EINIT_SLEEP_TIME);
> > +
> > +		if (signal_pending(current)) {
> > +			ret = -ERESTARTSYS;
> > +			goto err_out;
> > +		}
> > +	}
> > +
> > +	if (ret & ENCLS_FAULT_FLAG) {
> > +		if (encls_failed(ret))
> > +			ENCLS_WARN(ret, "EINIT");
> > +
> > +		sgx_encl_destroy(encl);
> > +		ret = -EFAULT;
> > +	} else if (ret) {
> > +		pr_debug("EINIT returned %d\n", ret);
> > +		ret = -EPERM;
> > +	} else {
> > +		atomic_or(SGX_ENCL_INITIALIZED, &encl->flags);
> > +	}
> > +
> > +err_out:
> > +	mutex_unlock(&encl->lock);
> > +	return ret;
> > +}
> > +
> > +/**
> > + * sgx_ioc_enclave_init - handler for %SGX_IOC_ENCLAVE_INIT
> > + *
> > + * @filep:	open file to /dev/sgx
> 
> @encl:       pointer to an enclave instance (via ioctl() file pointer)
> 
> > + * @arg:	userspace pointer to a struct sgx_enclave_init instance
> > + *
> > + * Flush any outstanding enqueued EADD operations and perform EINIT.  The
> > + * Launch Enclave Public Key Hash MSRs are rewritten as necessary to match
> > + * the enclave's MRSIGNER, which is caculated from the provided sigstruct.
> > + *
> > + * Return:
> > + *   0 on success,
> > + *   SGX error code on EINIT failure,
> > + *   -errno otherwise
> > + */
> > +static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
> > +{
> > +	struct sgx_sigstruct *sigstruct;
> > +	struct sgx_enclave_init einit;
> > +	struct page *initp_page;
> > +	void *token;
> > +	int ret;
> > +
> > +	if (!(atomic_read(&encl->flags) & SGX_ENCL_CREATED))
> 
> Might just as well check the other flags: doing EINIT on an already
> initialized enclave - SGX_ENCL_INITIALIZED - is perhaps a nono or
> similarly on a SGX_ENCL_DEAD enclave.
> 
> And you could do similar sanity checks in the other ioctl functions.

Ya, as above, SGX_ENCL_INITIALIZED can be checked here.

SGX_ENCL_DEAD is actually already checked in in the top level sgx_ioctl(),
i.e. the check in sgx_encl_add_page() can technically be flat out dropped.

I say "technically" because I'm a bit torn over SGX_ENCL_DEAD; encl->lock
must be held to SGX_ENCL_DEAD (the page fault and reclaim flows rely on
this), but as it stands today only ioctl() paths (guarded by SGX_ENCL_IOCTL)
and sgx_release() (makes the ioctls() unreachable) set SGX_ENCL_DEAD.

So it's safe to check SGX_ENCL_DEAD from ioctl() context without holding
encl->lock, at least in the current code base, but it feels weird/sketchy.

In the end I don't think I have a strong opinion.  Removing the technically
unnecessary DEAD check in sgx_encl_add_page() is the simplest change, so it
may make sense to do that and nothing more for initial upstreaming.  Long
term, I fully expect we'll add paths that set SGX_ENCL_DEAD outside of
ioctl() context, e.g. to handle EPC OOM, but it wouldn't be a bad thing to
have a standalone commit in a future series to add DEAD checks (under
encl->lock) in the ADD and INIT flows.
