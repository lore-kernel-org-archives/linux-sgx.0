Return-Path: <SRS0=YjYT=DA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842CEC4363D
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 14:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47A3621D43
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 14:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgIWOwt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 23 Sep 2020 10:52:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:49825 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbgIWOws (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 23 Sep 2020 10:52:48 -0400
IronPort-SDR: Y+ygIClWD4BlRCvAL+Fq+crQCbqbA2n8k5dohAK1H56KpSspecam0BQqBERZXNwIScPGzBjenk
 CUghlYtGlVLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="160184157"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="160184157"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 07:52:48 -0700
IronPort-SDR: qUEm5QxgpAGCO2aoV1LrsO9HLm2WX4293w5KKnf3PN5TibQgf0JORYfs5oszLqHtNlN85SD23M
 9XHvO4GE2EAA==
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="486466005"
Received: from linortne-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.49.223])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 07:52:41 -0700
Date:   Wed, 23 Sep 2020 17:52:39 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Jethro Beekman <jethro@fortanix.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 16/24] x86/sgx: Add a page reclaimer
Message-ID: <20200923145239.GG5160@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-17-jarkko.sakkinen@linux.intel.com>
 <20200922104538.GE22660@zn.tnic>
 <20200922140314.GA164527@linux.intel.com>
 <20200922142413.GH22660@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922142413.GH22660@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 22, 2020 at 04:24:13PM +0200, Borislav Petkov wrote:
> On Tue, Sep 22, 2020 at 05:03:23PM +0300, Jarkko Sakkinen wrote:
> > On Tue, Sep 22, 2020 at 12:45:38PM +0200, Borislav Petkov wrote:
> > > > + * %SGX_ENCL_PAGE_VA_OFFSET_MASK:	Holds the offset in the Version Array
> > > > + *					(VA) page for a swapped page.
> > > >   * %SGX_ENCL_PAGE_ADDR_MASK:		Holds the virtual address of the page.
> > > >   *
> > > >   * The page address for SECS is zero and is used by the subsystem to recognize
> > > 
> > > ...
> > 
> > So what's wrong over here?
> 
> Nothing - that's just an ellipsis: https://en.wikipedia.org/wiki/Ellipsis
> 
> I do that because otherwise you'd have to scroll through pages of quoted
> mail for no good reason and that ain't friendly at all. And I notice
> people not trimming their replies and not quoting only the text they
> reply to. They should not wonder if their emails remain unread.
> 
> Thx for the rest.

OK, I'm just almost paranoic in not addressing all feedback, thanks
for the explanation :-)

Like in this version, I'll try to xref all changes so it will be at
least easier spot if something is missing.

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
