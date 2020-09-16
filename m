Return-Path: <SRS0=APC0=CZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E78CC433E2
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 21:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 094E520731
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 21:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgIPVES (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Sep 2020 17:04:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:38422 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgIPQPB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Sep 2020 12:15:01 -0400
IronPort-SDR: 9FHXkSbyrIE5nM8ruif5bBBi09AlmJWYCzdHxyPUub+LaAhiMV/LZbKEUpJsTyL63wTePIRqm8
 82Cl6oxVyzfQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="177577409"
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="177577409"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 09:10:48 -0700
IronPort-SDR: pESb1QCy6wrVLKVJGpZbs3bTRkGbUfn8V5nnfhT7Lqd0YKYKlpEPNqGYQfFLhNRkKj5XZ7Gvj/
 PjRrX8S+Rtow==
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="483367624"
Received: from scusackx-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.45.87])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 09:10:39 -0700
Date:   Wed, 16 Sep 2020 19:10:37 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, haitao.huang@intel.com, josh@joshtriplett.org,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com
Subject: Re: [PATCH v37 13/24] x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
Message-ID: <20200916161037.GD21026@linux.intel.com>
References: <20200911124019.42178-1-jarkko.sakkinen@linux.intel.com>
 <20200911124019.42178-14-jarkko.sakkinen@linux.intel.com>
 <op.0qwyftihwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20200915095450.GH3612@linux.intel.com>
 <20200915101752.GA883054@linux.intel.com>
 <2156a91c-cf24-bf8b-8680-bd2598e0706d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2156a91c-cf24-bf8b-8680-bd2598e0706d@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 15, 2020 at 07:49:15AM -0700, Dave Hansen wrote:
> On 9/15/20 3:17 AM, Jarkko Sakkinen wrote:
> > OK, spotted the regression, sorry about this. I'll fix it for v38, which
> > I'm sending soon given the email server issues with v37.
> 
> I'm going to cry uncle on the mail quantity too.  Someone is going to
> think the mail relays are mining bitcoin.
> 
> Especially all of us on cc, we don't need multiple copies.  I'd suggest
> throwing your series up on github and then make sure your cover letter
> gets through.  If anyone is missing a patch, they can just yank it out
> of the git repo.

The v38 copies should be complete and good.

The only issue is that it has now two duplicate copies. 

/Jarkko
