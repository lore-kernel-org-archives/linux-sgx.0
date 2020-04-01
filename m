Return-Path: <SRS0=Q2Hp=5R=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC38DC43331
	for <linux-sgx@archiver.kernel.org>; Wed,  1 Apr 2020 08:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B74220772
	for <linux-sgx@archiver.kernel.org>; Wed,  1 Apr 2020 08:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbgDAIpq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 1 Apr 2020 04:45:46 -0400
Received: from mga04.intel.com ([192.55.52.120]:53776 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730420AbgDAIpq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 1 Apr 2020 04:45:46 -0400
IronPort-SDR: SmyADYPUmPhh1alZVEXW1CERKd4g3NAGfu5EbtN3Biz6NRkyjpx0I9Zmp/HaINiJIlmYzbTAlR
 LTMbg4mUd+xQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2020 01:45:45 -0700
IronPort-SDR: R6ldtOZWk+dE8hNI2NwqNtDHAFb41zsTzJxabc8oP9yY3J/P4mpo6woOhFmuNaUY7U3DIBKgWk
 TBLbb+nUtZ3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,331,1580803200"; 
   d="scan'208";a="450464627"
Received: from vikasjox-mobl.amr.corp.intel.com (HELO localhost) ([10.249.39.53])
  by fmsmga006.fm.intel.com with ESMTP; 01 Apr 2020 01:45:41 -0700
Date:   Wed, 1 Apr 2020 11:45:39 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        ismo.puustinen@intel.com, mikko.ylinen@intel.com
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Message-ID: <20200401084511.GE17325@linux.intel.com>
References: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com>
 <20200331114432.7593-3-jarkko.sakkinen@linux.intel.com>
 <CALCETrXz4YK9ubCAyBLm4BjqYEK-wt1491QPLDyumJe9t0LJ2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXz4YK9ubCAyBLm4BjqYEK-wt1491QPLDyumJe9t0LJ2A@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 31, 2020 at 10:39:38AM -0700, Andy Lutomirski wrote:
> On Tue, Mar 31, 2020 at 4:44 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > When creating an enclave attach it to an anonymous file. This prepares the
> > code to have a separate interface at runtime, which can be published to the
> > user space after the enclave has been fully initialized.
> 
> This isn't an objection per se, but I can't shake the feeling that
> this seems ridiculous.  This changes the type of object returned by
> open() because, without this change, the old type was problematic.
> 
> So I have some questions:
> 
>  - Can sgx just ignore the fs noexec option on the chardev inode's fs instead?

It's not SGX that nak's. It's mm level decision.

>  - Would SELinux users *want* to put a useful label on the inode?  if
> so, can they still accomplish whatever they were trying to accomplish
> with this patch applied?

What this does is that by default SGX is essentially blocked from
anything, which I think is sane. I think from security perspective
the EXECMEM requirement brings more clarity than does harm.

I'm sure that with this approach it is possible to integrate SGX to
software packages such as Kubernetes and end users will most likely
take into use through something like Kubernetes.

/Jarkko
