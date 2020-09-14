Return-Path: <SRS0=Mf4r=CX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5462C433E2
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Sep 2020 16:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DAD421974
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Sep 2020 16:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgINQPq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Sep 2020 12:15:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:13774 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbgINQOC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 14 Sep 2020 12:14:02 -0400
IronPort-SDR: EYHKivvfr7FKJ6ln9K+ec9JGrtaIvxiKpWVepSBrRR6eytE3d99R5vgeMs4PKClhHwHYhaLPHJ
 cYLHGEoERF9Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="158387388"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="158387388"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 09:13:59 -0700
IronPort-SDR: lPs5notI7pfW/v0x2bYMRlv4zYfXJWQn/fMh5NeEuRHmI6/6xLT9OJRccG7/FGoUXm6gEJqnhk
 o0FcHVw77frg==
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="450937896"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 09:13:59 -0700
Date:   Mon, 14 Sep 2020 09:13:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v37 02/24] x86/cpufeatures: x86/msr: Add Intel SGX Launch
 Control hardware bits
Message-ID: <20200914161357.GG6855@sjchrist-ice>
References: <20200911124019.42178-1-jarkko.sakkinen@linux.intel.com>
 <20200911124019.42178-3-jarkko.sakkinen@linux.intel.com>
 <20200914151816.u6camicid4bd5lgo@treble>
 <20200914153812.c6uh3spqmcy2ft3d@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914153812.c6uh3spqmcy2ft3d@treble>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 14, 2020 at 10:38:12AM -0500, Josh Poimboeuf wrote:
> On Mon, Sep 14, 2020 at 10:18:16AM -0500, Josh Poimboeuf wrote:
> > Hi Jarko,
> > 
> > It looks like some of the patches weren't delivered to the lists.
> > Patches 0, 1, 8, 9, and 17 seem to be missing.
> > 
> > Lore agrees with me:
> > 
> >   https://lore.kernel.org/linux-sgx/20200911124019.42178-1-jarkko.sakkinen@linux.intel.com/
> 
> And my first email to you bounced, similar to an email I tried sending
> to Kristen a few weeks ago.  Something weird going on with Intel mail
> servers?

Probably.  Our exchange servers got upgraded and many of the endpoints got
changed in the process.  It wouldn't surprise me in the least if there are
gremlins in the new setup.
