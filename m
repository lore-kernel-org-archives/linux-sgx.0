Return-Path: <SRS0=Nw9Y=X6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C277C47404
	for <linux-sgx@archiver.kernel.org>; Sat,  5 Oct 2019 15:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A66A222CA
	for <linux-sgx@archiver.kernel.org>; Sat,  5 Oct 2019 15:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbfJEPyQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 5 Oct 2019 11:54:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:25133 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbfJEPyP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 5 Oct 2019 11:54:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Oct 2019 08:54:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,260,1566889200"; 
   d="scan'208";a="222456842"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 05 Oct 2019 08:54:13 -0700
Date:   Sat, 5 Oct 2019 08:54:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
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
Message-ID: <20191005155412.GA9159@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-17-jarkko.sakkinen@linux.intel.com>
 <20191002231804.GA14315@linux.intel.com>
 <20191004001459.GD14325@linux.intel.com>
 <20191004185221.GI6945@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004185221.GI6945@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 04, 2019 at 09:52:21PM +0300, Jarkko Sakkinen wrote:
> On Thu, Oct 03, 2019 at 05:15:00PM -0700, Sean Christopherson wrote:
> > I'll tackle this tomorrow.  I've been working on the feature control MSR
> > series and will get that sent out tomorrow as well.  I should also be able
> > to get you the multi-page EADD patch.
> 
> Great I'll compose the patch set during the weekend and take Monday off
> so you have the full work day to get everything (probably send the patch
> set on Sunday).

Didn't get to the actual SGX stuff yesterday as the feature control series
took longer than expected to finish.  Working on the other items this
morning.
