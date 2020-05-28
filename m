Return-Path: <SRS0=sWWJ=7K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8BA3C433E1
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 05:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88B0920721
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 05:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbgE1FQk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 May 2020 01:16:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:1646 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727866AbgE1FNe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 28 May 2020 01:13:34 -0400
IronPort-SDR: ZKMVKwoNJcxY87oGn5ZnXK8C+Sr98cBsLIuzWJPk5kuQaAtOsgxVjx/cGPtvI8V6FbmKIf4qwu
 mSFzbbCsbogQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 22:13:33 -0700
IronPort-SDR: enoUrQ5QFuqRwd2IG/kk76A5FrNr4x6c280uzLz7f93LgPpJDDpxv9zEE24NlmyGOH0HBTWCBA
 BJ1kfX7A3uXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="302352681"
Received: from dmescala-mobl1.amr.corp.intel.com (HELO localhost) ([10.252.59.102])
  by fmsmga002.fm.intel.com with ESMTP; 27 May 2020 22:13:24 -0700
Date:   Thu, 28 May 2020 08:13:23 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 07/20] x86/sgx: Enumerate and track EPC sections
Message-ID: <20200528051323.GA6613@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-8-jarkko.sakkinen@linux.intel.com>
 <20200525092304.GD25636@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200525092304.GD25636@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, May 25, 2020 at 11:23:04AM +0200, Borislav Petkov wrote:
> Enabling this gives:
> 
> In file included from arch/x86/kernel/cpu/sgx/main.c:11:
> arch/x86/kernel/cpu/sgx/encls.h:189:51: warning: ‘struct sgx_einittoken’ declared inside parameter list will not be visible outside of this definition or declaration
>   189 | static inline int __einit(void *sigstruct, struct sgx_einittoken *einittoken,
>       |                                                   ^~~~~~~~~~~~~~
> In file included from arch/x86/kernel/cpu/sgx/reclaim.c:12:
> arch/x86/kernel/cpu/sgx/encls.h:189:51: warning: ‘struct sgx_einittoken’ declared inside parameter list will not be visible outside of this definition or declaration
>   189 | static inline int __einit(void *sigstruct, struct sgx_einittoken *einittoken,
>       |
> 
> You need a forward declaration somewhere.

It is a left-over from v28 and should be "void *".

To backtrack what happened it looks that I squashed the change that
does this to "x86/sgx: Linux Enclave Driver".

This is fixed now in my tree.

/Jarkko
