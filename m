Return-Path: <SRS0=PIOK=C3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61231C43464
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Sep 2020 12:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 258F62073A
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Sep 2020 12:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgIRMjp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Sep 2020 08:39:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:8744 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbgIRMjp (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 18 Sep 2020 08:39:45 -0400
IronPort-SDR: FZTBJDIisOZURwgzwmR/kghkAZfKrO2Xq3XSMlAUDuL92SujTOJwYf9ydtBDdj3/OW8UgaGKgU
 kgMn1dXqofOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="159228030"
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="159228030"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 05:39:41 -0700
IronPort-SDR: RVmHQUloGyO2WOwLA1djftg4KQ39XZfOk34f5nJ65/WsdNTH4V/oMoYzgpPiug4Jm9a8pIzJpM
 XthzOP961LSA==
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="484189699"
Received: from dlos-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.48.212])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 05:39:34 -0700
Date:   Fri, 18 Sep 2020 15:39:32 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
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
Message-ID: <20200918123932.GB27028@linux.intel.com>
References: <20200915110522.893152-1-jarkko.sakkinen@linux.intel.com>
 <20200915110522.893152-14-jarkko.sakkinen@linux.intel.com>
 <op.0q2prldowjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20200917160206.GF8530@linux.intel.com>
 <op.0q3pw0stwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20200918020940.GA14678@sjchrist-ice>
 <20200918122029.GA27028@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918122029.GA27028@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 18, 2020 at 03:20:39PM +0300, Jarkko Sakkinen wrote:
> On Thu, Sep 17, 2020 at 07:09:40PM -0700, Sean Christopherson wrote:
> > On Thu, Sep 17, 2020 at 01:35:10PM -0500, Haitao Huang wrote:
> > > On Thu, 17 Sep 2020 11:02:06 -0500, Jarkko Sakkinen
> > > <jarkko.sakkinen@linux.intel.com> wrote:
> > > > 
> > > > Right, I do get the OOM case but wouldn't in that case the reasonable
> > > > thing to do destroy the enclave that is not even running? I mean that
> > > > means that we are globally out of EPC.
> > > > 
> > > 
> > > I would say it could be a policy, but not the only one. If it does not make
> > > much difference to kernel, IMHO we should  not set it in stone now.
> > > Debugging is also huge benefit to me.
> > 
> > Agreed, an EPC cgroup is the proper way to define/enforce what happens when
> > there is EPC pressure.  E.g. if process A is consuming 99% of the EPC, then
> > it doesn't make sense to unconditionally kill enclaves from process B.  If
> > the admin wants to give process A priority, so be it, but such a decision
> > shouldn't be baked into the kernel.
> > 
> > This series obviously doesn't provide an EPC cgroup, but that doesn't mean
> > we can't make decisions that will play nice with a cgroup in the future.
> 
> Here's the core issue why the API "as is used to be" does not work:
> 
> 	if (ret == -EIO) {
> 		mutex_lock(&encl->lock);
> 		sgx_encl_destroy(encl);
> 		mutex_unlock(&encl->lock);
> 	}
> 
> It would be better to instead whitelist *when* the enclave is preserved.
> 
> 	if (ret != -ENOMEM) {
> 		mutex_lock(&encl->lock);
> 		sgx_encl_destroy(encl);
> 		mutex_unlock(&encl->lock);
> 	}
> 
> That is the information we *deterministically* want to know. Otherwise,
> we will live in ultimate chaos.
> 
> Only this way can caller know when there are means to continue, and when
> to quit. I.e. the code is whitelisting wrong way around currently.

Actually since the state cannot corrupt unless EADD or EEXTEND fails it
is fine to have the enclave alive on any other error condition. I think
what I do is that I move the check out sgx_encl_add_page() to the main
ioctl and update the kdoc. It is not too clear on persistence. I'll fix
this.

/Jarkko
