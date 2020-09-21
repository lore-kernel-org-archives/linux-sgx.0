Return-Path: <SRS0=03YQ=C6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CDCAC43466
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 16:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8B89206DC
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 16:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730161AbgIUQxz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Sep 2020 12:53:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:39232 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729588AbgIUQqv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 21 Sep 2020 12:46:51 -0400
IronPort-SDR: aIj0Qjj0Yn3rKhcoyXRxrhgIqDyefr9U56hnUub8e6mxZexPtRS/PteSWzm/FjWRMt7nxdjAK/
 oY/CwQHXiMSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="148086189"
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="148086189"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 09:46:50 -0700
IronPort-SDR: 9GtvB/4scFuhsj0BSxHP7xgAfyRraeNQPQxyYlLLKY/kwPG4xZvo5SDm36REipyR1Wfwixadhw
 epj3k54ETpqw==
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="321829644"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 09:46:49 -0700
Date:   Mon, 21 Sep 2020 09:46:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 13/24] x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
Message-ID: <20200921164647.GC23989@linux.intel.com>
References: <20200915110522.893152-1-jarkko.sakkinen@linux.intel.com>
 <20200915110522.893152-14-jarkko.sakkinen@linux.intel.com>
 <op.0q2prldowjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20200917160206.GF8530@linux.intel.com>
 <op.0q3pw0stwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20200918020940.GA14678@sjchrist-ice>
 <20200918122029.GA27028@linux.intel.com>
 <20200918123932.GB27028@linux.intel.com>
 <20200919000918.GB21189@sjchrist-ice>
 <20200921114104.GB6038@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921114104.GB6038@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 21, 2020 at 02:41:04PM +0300, Jarkko Sakkinen wrote:
> On Fri, Sep 18, 2020 at 05:09:19PM -0700, Sean Christopherson wrote:
> > On Fri, Sep 18, 2020 at 03:39:32PM +0300, Jarkko Sakkinen wrote:
> > > On Fri, Sep 18, 2020 at 03:20:39PM +0300, Jarkko Sakkinen wrote:
> > > > On Thu, Sep 17, 2020 at 07:09:40PM -0700, Sean Christopherson wrote:
> > > > > On Thu, Sep 17, 2020 at 01:35:10PM -0500, Haitao Huang wrote:
> > > > > > On Thu, 17 Sep 2020 11:02:06 -0500, Jarkko Sakkinen
> > > > > > <jarkko.sakkinen@linux.intel.com> wrote:
> > > > > > > 
> > > > > > > Right, I do get the OOM case but wouldn't in that case the reasonable
> > > > > > > thing to do destroy the enclave that is not even running? I mean that
> > > > > > > means that we are globally out of EPC.
> > > > > > > 
> > > > > > 
> > > > > > I would say it could be a policy, but not the only one. If it does not make
> > > > > > much difference to kernel, IMHO we should  not set it in stone now.
> > > > > > Debugging is also huge benefit to me.
> > > > > 
> > > > > Agreed, an EPC cgroup is the proper way to define/enforce what happens when
> > > > > there is EPC pressure.  E.g. if process A is consuming 99% of the EPC, then
> > > > > it doesn't make sense to unconditionally kill enclaves from process B.  If
> > > > > the admin wants to give process A priority, so be it, but such a decision
> > > > > shouldn't be baked into the kernel.
> > > > > 
> > > > > This series obviously doesn't provide an EPC cgroup, but that doesn't mean
> > > > > we can't make decisions that will play nice with a cgroup in the future.
> > > > 
> > > > Here's the core issue why the API "as is used to be" does not work:
> > > > 
> > > > 	if (ret == -EIO) {
> > > > 		mutex_lock(&encl->lock);
> > > > 		sgx_encl_destroy(encl);
> > > > 		mutex_unlock(&encl->lock);
> > > > 	}
> > > > 
> > > > It would be better to instead whitelist *when* the enclave is preserved.
> > > > 
> > > > 	if (ret != -ENOMEM) {
> > > > 		mutex_lock(&encl->lock);
> > > > 		sgx_encl_destroy(encl);
> > > > 		mutex_unlock(&encl->lock);
> > > > 	}
> > > > 
> > > > That is the information we *deterministically* want to know. Otherwise,
> > > > we will live in ultimate chaos.
> > > > 
> > > > Only this way can caller know when there are means to continue, and when
> > > > to quit. I.e. the code is whitelisting wrong way around currently.
> > > 
> > > Actually since the state cannot corrupt unless EADD or EEXTEND fails it
> > > is fine to have the enclave alive on any other error condition. I think
> > 
> > EADD and EEXTEND failure don't corrupt state.  Killing the enclave if EEXTEND
> > fails makes sense because failure at that point is either due to a kernel bug
> > or loss of EPC, both of which are fatal to the enclave.
> 
> This is also true. I meant by corrupt state e.g. a kernel bug, which
> causes uninitalizes pages go the free queue.
> 
> I'd rephrase this in kdoc as: "The function deinitializes enclave and
> returns -EIO when EPC is lost, while entering to a new power cycle".

The kdocs shouldn't speculate on why EEXTEND might fail.  E.g. in some (and
possibility most) environments, the most common scenario of EEXTEND failure
will be EPC invalidation due to virtual machine migration.

This is why I'd prefer that the kernel kill the enclave if and only if the
error is guaranteed to be fatal, e.g. the docs can have a blanket statement
along the lines of:

  An enclave will be killed and its EPC resources will be freed if an error that
  is guaranteed to be fatal is encountered at any time, e.g. if EEXTEND fails as
  EEXTEND can only fail due to loss of EPC, a kernel bug, or silicon bug, all of
  which are unrecoverable.
 
> Documentation describes only legit behaviour, let's ignore the corrupt
> part.
> 
> > EADD is a little different, e.g. it could fault due to a bad source address,
> > in which case the failure is not technically fatal.  But, Jarkko wanted to
> > have consistent behavior for EADD and EEXTEND failures, and practically
> > speaking the enclave is probably hosed anyways if EADD fails, i.e. killing the
> > enclave on EADD failure isn't a sticking point (for me).
> 
> We need to figure out own return value for EADD, but I agree with this.
> 
> I would go with -EFAULT as we do when source VMA is no available. Does
> this make sense to you?

If only EEXTEND will be treated as fatal, then I see no need to worry about
the return code for EADD.  In that case, simply kill the enclave on EEXTEND
failure instead of on a specific return code.
