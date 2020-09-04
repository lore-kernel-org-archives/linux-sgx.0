Return-Path: <SRS0=DCUR=CN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B145C43461
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 13:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBD1E204FD
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 13:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgIDNqu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Sep 2020 09:46:50 -0400
Received: from mga06.intel.com ([134.134.136.31]:16634 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730632AbgIDNqV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Sep 2020 09:46:21 -0400
IronPort-SDR: ynz313lDP3ZFqJwut/73ZeEbaolJk23FS7IObmGVCaUXhCDqGEP7jKu3Tc7DvPS0PZvVAFJmrZ
 WjLycHjw6IFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="219295821"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="219295821"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 06:46:16 -0700
IronPort-SDR: OVgr7LOrvxvkA3SEAx5vmD0vRjLJL3chqqOGSHE+0ozMNkBYuf8QANElU94lz0aSc8lM67ZDwI
 0YPoHcCEsISw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="478493463"
Received: from pipper-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.56.104])
  by orsmga005.jf.intel.com with ESMTP; 04 Sep 2020 06:46:14 -0700
Date:   Fri, 4 Sep 2020 16:46:13 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v37 2/6] x86/vdso: x86/sgx: Rework
 __vdso_sgx_enter_enclave() API
Message-ID: <20200904134613.GG39023@linux.intel.com>
References: <20200904104437.29555-1-sean.j.christopherson@intel.com>
 <20200904104437.29555-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904104437.29555-3-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 04, 2020 at 03:44:33AM -0700, Sean Christopherson wrote:
> Rework __vdso_sgx_enter_enclave() to use a struct to hold the input and
> output params.  In the new struct, add an opaque "user_data" that can be
> used to pass context across the vDSO, an explicit "exit_reason" to avoid
> overloading the return value, and a "flags" field to provide a path for
> future extensions.
> 
> Moving the params into a struct will also make it less painful to use
> dedicated exit reasons values in a future patch.
> 
> Cc: Nathaniel McCallum <npmccallum@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

I like this a lot. Everything is now so much better tied together.

If I understood the change correctly this solution also addreses my
concerns of eBPF because 'flags' allows to change representation what
handler means (later on, if we ever want).

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
