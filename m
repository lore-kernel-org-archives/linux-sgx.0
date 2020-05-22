Return-Path: <SRS0=O4vE=7E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0987FC433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 21:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF24420671
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 21:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731066AbgEVVwr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 May 2020 17:52:47 -0400
Received: from mga04.intel.com ([192.55.52.120]:34307 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731051AbgEVVwr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 May 2020 17:52:47 -0400
IronPort-SDR: LG1IWQXu/JBdgLtXIelMcLu9Kw/SyDCsDUFpwd1lhnOnjBLg7GNjToVijJ6s7LW3DPuJS0UrDM
 RV8kSyfj0uAQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 14:52:45 -0700
IronPort-SDR: w0eSIGE/0ed2ljj0/MFvqOPI8oRzvQgTxR//H2BaaQg4eHpzJ7vnlvJVcjhG+ujHcBF/s87HUP
 DP4VhEgytrJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,423,1583222400"; 
   d="scan'208";a="344292728"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 22 May 2020 14:52:45 -0700
Date:   Fri, 22 May 2020 14:52:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-mm@kvack.org, Jethro Beekman <jethro@fortanix.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Seth Moore <sethmo@google.com>
Subject: Re: [PATCH v30 12/20] x86/sgx: Add a page reclaimer
Message-ID: <20200522215245.GD25128@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-13-jarkko.sakkinen@linux.intel.com>
 <20200522065802.GC23459@linux.intel.com>
 <20200522195705.GA121599@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522195705.GA121599@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 22, 2020 at 10:57:05PM +0300, Jarkko Sakkinen wrote:
> v31:
> * Unset SGX_ENCL_IOCTL in the error path of checking encl->flags in order
>   to prevent leaving it set and thus block any further ioctl calls.
> * Added missing cleanup_srcu_struct() call to sgx_encl_release().
> * Take encl->lock in sgx_encl_add_page() in order to prevent races with
>   the page reclaimer.
> * Fix a use-after-free bug from page reclaimer. Call kref_put() for the
>   encl->refcount only after putting enclave page back to the active page
>   list because it could be the last ref to the enclave.
> 
> I'm ready to send a new version of the patch set once there is a
> conclusion with the sigstruct vendor field.

Fire away, nothing pending on my end, the cgroup tests appear to be running
clean.
