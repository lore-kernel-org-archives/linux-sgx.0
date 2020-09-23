Return-Path: <SRS0=YjYT=DA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A1FC2D0A8
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 13:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D311321BE5
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 13:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgIWNoD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 23 Sep 2020 09:44:03 -0400
Received: from mga17.intel.com ([192.55.52.151]:53608 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726504AbgIWNoD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 23 Sep 2020 09:44:03 -0400
IronPort-SDR: /dItL0OQ9F6sBv0JFp2DrwuuwhIwUaI39abJo4A6LQUPXVamhak+TJhlgpMhM2Z4ogI4GZoQz7
 ZkYbw8wfJvLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9752"; a="140901187"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="140901187"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 06:44:02 -0700
IronPort-SDR: Lme8ty7I/g9PsqiJtR4D47YuMqBd6NyLtzEbVFSirhG42hpuJfcvDa0Pv2wpB7D/5OOvaVoo9X
 8JjxHTb7FwpQ==
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="486445607"
Received: from ichiojdo-mobl.ger.corp.intel.com (HELO localhost) ([10.252.51.82])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 06:43:54 -0700
Date:   Wed, 23 Sep 2020 16:43:52 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
Message-ID: <20200923134352.GC5160@linux.intel.com>
References: <20200918235337.GA21189@sjchrist-ice>
 <1B23E216-0229-4BDD-8B09-807256A54AF5@amacapital.net>
 <20200922125801.GA133710@linux.intel.com>
 <25d46fdc-1c19-2de8-2ce8-1033a0027ecf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25d46fdc-1c19-2de8-2ce8-1033a0027ecf@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 22, 2020 at 08:11:14AM -0700, Dave Hansen wrote:
> On 9/22/20 5:58 AM, Jarkko Sakkinen wrote:
> > Intel Sofware Guard eXtensions (SGX) allows creation of executable blobs
> > called enclaves, of which page permissions are defined when the enclave
> 
> "of which" => "for which"
> 
> > is first loaded. Once an enclave is loaded and initialized, it can be
> > mapped to the process address space.
> 
> Could you compare and contrast this a *bit* with existing executables?
> What's special about SGX?  ELF executables have page permissions inside
> the binary too.  Why don't we use this mechanism for them?

There is no standard file format for enclaves. They are dynamically
built. And the way enclaves are used as part of an app and throwing
container inside enclave differ. A single format would no work too
well for all possible use cases.

I cannot formally prove this of course but it is highly unlikely that
we could ever define such a format. Thus, the security focus is allow
to verify from origin.

And the existing ecosystem around SGX is already too large to suddenly
move to a single format. User base, I guess, is also an argument. This
is not yet mainline code so technically we have zero ABI debt but I
still think this is a valid point because SGX is already widely used.

I'm not really sure what would be the best way to nail this information
to the commit message but I'll try to figure out something before I send
the next version of the patch set.

/Jarkko
