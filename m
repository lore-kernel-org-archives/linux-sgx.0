Return-Path: <SRS0=PIOK=C3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A0EBC43464
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Sep 2020 02:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A17923976
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Sep 2020 02:46:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbgIRCqf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:46:35 -0400
Received: from mga12.intel.com ([192.55.52.136]:31936 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728370AbgIRCJv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 17 Sep 2020 22:09:51 -0400
IronPort-SDR: bORU1zvJR/JQw82R2v53a3kaBXp12yg42rry5d1mblBZTNkDJWy0AzHu66MtiL8mPLluC3qtpw
 HweWkdO+YgyA==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="139337419"
X-IronPort-AV: E=Sophos;i="5.77,273,1596524400"; 
   d="scan'208";a="139337419"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 19:09:46 -0700
IronPort-SDR: G9KvBwy6V2uVOVk3tYQOh0Ifnm8hTAnrhmaSt2F5hjw+Lq0hrVb+eto6gRVk9I5sM8WCmZIAYJ
 ntx+nlL77N9g==
X-IronPort-AV: E=Sophos;i="5.77,273,1596524400"; 
   d="scan'208";a="307701014"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 19:09:43 -0700
Date:   Thu, 17 Sep 2020 19:09:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
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
Message-ID: <20200918020940.GA14678@sjchrist-ice>
References: <20200915110522.893152-1-jarkko.sakkinen@linux.intel.com>
 <20200915110522.893152-14-jarkko.sakkinen@linux.intel.com>
 <op.0q2prldowjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20200917160206.GF8530@linux.intel.com>
 <op.0q3pw0stwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.0q3pw0stwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 17, 2020 at 01:35:10PM -0500, Haitao Huang wrote:
> On Thu, 17 Sep 2020 11:02:06 -0500, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> > 
> > Right, I do get the OOM case but wouldn't in that case the reasonable
> > thing to do destroy the enclave that is not even running? I mean that
> > means that we are globally out of EPC.
> > 
> 
> I would say it could be a policy, but not the only one. If it does not make
> much difference to kernel, IMHO we should  not set it in stone now.
> Debugging is also huge benefit to me.

Agreed, an EPC cgroup is the proper way to define/enforce what happens when
there is EPC pressure.  E.g. if process A is consuming 99% of the EPC, then
it doesn't make sense to unconditionally kill enclaves from process B.  If
the admin wants to give process A priority, so be it, but such a decision
shouldn't be baked into the kernel.

This series obviously doesn't provide an EPC cgroup, but that doesn't mean
we can't make decisions that will play nice with a cgroup in the future.
