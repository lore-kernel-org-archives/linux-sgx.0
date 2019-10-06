Return-Path: <SRS0=PqqZ=X7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C3AFC4360C
	for <linux-sgx@archiver.kernel.org>; Sun,  6 Oct 2019 23:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7215D2080F
	for <linux-sgx@archiver.kernel.org>; Sun,  6 Oct 2019 23:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfJFXkU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 6 Oct 2019 19:40:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:7649 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbfJFXkU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 6 Oct 2019 19:40:20 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Oct 2019 16:40:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,265,1566889200"; 
   d="scan'208";a="192946807"
Received: from mwebb1-mobl.ger.corp.intel.com (HELO localhost) ([10.251.93.103])
  by fmsmga007.fm.intel.com with ESMTP; 06 Oct 2019 16:40:12 -0700
Date:   Mon, 7 Oct 2019 02:40:11 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v22 16/24] x86/vdso: Add support for exception fixup in
 vDSO functions
Message-ID: <20191006234011.GA16366@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-17-jarkko.sakkinen@linux.intel.com>
 <20191002231804.GA14315@linux.intel.com>
 <20191004001459.GD14325@linux.intel.com>
 <20191004185221.GI6945@linux.intel.com>
 <20191006233817.GC15594@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191006233817.GC15594@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 07, 2019 at 02:38:17AM +0300, Jarkko Sakkinen wrote:
> On Fri, Oct 04, 2019 at 09:52:21PM +0300, Jarkko Sakkinen wrote:
> > On Thu, Oct 03, 2019 at 05:15:00PM -0700, Sean Christopherson wrote:
> > > I'll tackle this tomorrow.  I've been working on the feature control MSR
> > > series and will get that sent out tomorrow as well.  I should also be able
> > > to get you the multi-page EADD patch.
> > 
> > Great I'll compose the patch set during the weekend and take Monday off
> > so you have the full work day to get everything (probably send the patch
> > set on Sunday).
> 
> I don't see why the multipage version could not be ioctl of its own and
> ioctl's can then use the same internals. Having a single page version
> does not cause any kind of bottleneck really.
> 
> Thus, sending now v23 based on these conclusions.

Sure, you can argue it is redudant but I see it as a nice convenience
for simple stuff that does not really hurt at all.

/Jarkko
