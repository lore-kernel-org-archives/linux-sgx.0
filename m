Return-Path: <SRS0=s70M=YA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECA2C47404
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Oct 2019 08:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D26D217D6
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Oct 2019 08:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfJGIBt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Oct 2019 04:01:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:29832 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbfJGIBs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 7 Oct 2019 04:01:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 01:01:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,265,1566889200"; 
   d="scan'208";a="205001898"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.161])
  by orsmga002.jf.intel.com with ESMTP; 07 Oct 2019 01:01:37 -0700
Date:   Mon, 7 Oct 2019 11:01:36 +0300
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
Message-ID: <20191007080136.GB5466@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-17-jarkko.sakkinen@linux.intel.com>
 <20191002231804.GA14315@linux.intel.com>
 <20191004001459.GD14325@linux.intel.com>
 <20191004185221.GI6945@linux.intel.com>
 <20191005183939.GB9159@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191005183939.GB9159@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Oct 05, 2019 at 11:39:39AM -0700, Sean Christopherson wrote:
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
> I wasn't able to finish everything this morning (not even close).  The
> vDSO code and documentation was in rough shape.  I finished cleaning it
> up, but still need to test and rewrite the changelog.
> 
> If you really want to send v23 this weekend I can work more tonight
> and/or tomorrow morning.  My preference would be to just punt a few more
> days.
> 
> My todo list for v23:
> 
>   - Test vDSO changes and craft proper patches
>   - Rewrite vDSO changelog
>   - Rewrite vDSO exception fixup changelog
>   - Implement multi-page EADD

For maintainer commit messages are at least as important as
documentation in the Documentation folder, if not more. If
they've been written well, they are useful when back tracking
history when fixing bugs and so forth.

> 
> My todo list post-v23:
>   - Write SGX programming model documentation (requested by Casey)

I'll wait up until I get your v23 changes. Try to get them as
fast as possible but without sacrificing quality.

/Jarkko
