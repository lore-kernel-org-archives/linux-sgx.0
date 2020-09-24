Return-Path: <SRS0=9T+I=DB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA10DC4363D
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 21:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9779A20575
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 21:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgIXVzd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 17:55:33 -0400
Received: from mga06.intel.com ([134.134.136.31]:45791 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbgIXVzd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 17:55:33 -0400
IronPort-SDR: mRpLz/4PSfGP47KhV+7PBYgvnoH1Ha4N40sMgvW5p/Lcw/ywWXnxCtr8elh07CXj/xRj5eDwMO
 uGy2FsM0Xh/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="222950699"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="222950699"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 14:55:31 -0700
IronPort-SDR: AkMp0QQSn+pgSPqyTMQhKVZ58RFR+QW7VRW8sy6EIH3jOoLPmPjl0mdG2T3tc2GcKG00Pi/lDX
 AOsRGmNSuX8w==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="511796388"
Received: from yshmidtx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.63.233])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 14:55:25 -0700
Date:   Fri, 25 Sep 2020 00:55:23 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v38 10/24] mm: Add vm_ops->mprotect()
Message-ID: <20200924215523.GA119995@linux.intel.com>
References: <20200918235337.GA21189@sjchrist-ice>
 <20200921124946.GF6038@linux.intel.com>
 <20200921165758.GA24156@linux.intel.com>
 <20200921210736.GB58176@linux.intel.com>
 <20200921211849.GA25403@linux.intel.com>
 <20200922052957.GA97272@linux.intel.com>
 <20200922053515.GA97687@linux.intel.com>
 <20200922164301.GB30874@linux.intel.com>
 <20200923135056.GD5160@linux.intel.com>
 <op.0rgp5h0hwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.0rgp5h0hwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 24, 2020 at 02:11:37PM -0500, Haitao Huang wrote:
> > For me this has caused months of confusion and misunderstanding of this
> > feature. I only recently realized that "oh, right, we invented this".
> > 
> > They are contrived scenarios enough that they should be considered when
> > the workloads hit.
> > 
> > Either we fully support noexec or not at all. Any "partial" thing is a
> > two edged sword: it can bring some robustness with the price of
> > complexity and possible unknown uknown scenarios where they might become
> > API issue.
> > 
> > I rather think later on how to extend API in some way to enable such
> > contrivid scenarios rather than worrying about how this could be abused.
> > 
> > The whole SGX is complex beast already so lets not add any extra when
> > there is no a hard requirement to do so.
> > 
> > I'll categorically deny noexec in the next patch set version.
> > 
> > /Jarkko
> 
> There are use cases supported currently in which enclave binary is received
> via IPC/RPC and held in buffers before EADD. Denying noexec altogether would
> break those, right?

I do not see why data cannot be provided at run-time. AFAIK, it is not
different from executables how this works when it comes to noexec.

/Jarkko
