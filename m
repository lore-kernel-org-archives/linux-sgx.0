Return-Path: <SRS0=a91O=6U=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF570C28CBC
	for <linux-sgx@archiver.kernel.org>; Wed,  6 May 2020 22:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C08BD2078C
	for <linux-sgx@archiver.kernel.org>; Wed,  6 May 2020 22:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgEFWOY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 6 May 2020 18:14:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:5914 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729907AbgEFWOY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 6 May 2020 18:14:24 -0400
IronPort-SDR: MqlXIOF+p6TBh/uiJTNVxso8C9alj+KzpJynjm2p7heVK3cEy9NT6DtBigF4sAOYz+Ft9DWZSW
 FTOJhVySdNnw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 15:14:23 -0700
IronPort-SDR: Uneb1M7Psi3ugumKhUNct7/f26jE2pWT5+4AbHUaJmznhT/LdWVnTzyBAxCk0K46oz1mbrEcmn
 1vP8utLkNd9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,360,1583222400"; 
   d="scan'208";a="369930304"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 06 May 2020 15:14:22 -0700
Date:   Wed, 6 May 2020 15:14:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200506221422.GK3329@linux.intel.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <CAOASepPFe_ucuwe7JW_-+VBQ4=+sHqyGXOdA9kUbcYA_9=v0sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOASepPFe_ucuwe7JW_-+VBQ4=+sHqyGXOdA9kUbcYA_9=v0sA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 06, 2020 at 05:42:42PM -0400, Nathaniel McCallum wrote:
> Tested on Enarx. This requires a patch[0] for v29 support.
> 
> Tested-by: Nathaniel McCallum <npmccallum@redhat.com>
> 
> However, we did uncover a small usability issue. See below.
> 
> [0]: https://github.com/enarx/enarx/pull/507/commits/80da2352aba46aa7bc6b4d1fccf20fe1bda58662

...

> > * Disallow mmap(PROT_NONE) from /dev/sgx. Any mapping (e.g. anonymous) can
> >   be used to reserve the address range. Now /dev/sgx supports only opaque
> >   mappings to the (initialized) enclave data.
> 
> The statement "Any mapping..." isn't actually true.
> 
> Enarx creates a large enclave (currently 64GiB). This worked when we
> created a file-backed mapping on /dev/sgx/enclave. However, switching
> to an anonymous mapping fails with ENOMEM. We suspect this is because
> the kernel attempts to allocate all the pages and zero them but there
> is insufficient RAM available. We currently work around this by
> creating a shared mapping on /dev/zero.

Hmm, the kernel shouldn't actually allocate physical pages unless they're
written.  I'll see if I can reproduce.
 
> If we want to keep this mmap() strategy, we probably don't want to
> advise mmap(ANON) if it allocates all the memory for the enclave ahead
> of time, even if it won't be used. This would be wasteful.
> 
> OTOH, having to mmap("/dev/zero") seems a bit awkward.
