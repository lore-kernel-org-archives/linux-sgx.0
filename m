Return-Path: <SRS0=yZGw=UK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7195C31E44
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Jun 2019 22:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 859B9205ED
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Jun 2019 22:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392021AbfFKWCr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Jun 2019 18:02:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:21062 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392014AbfFKWCr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 11 Jun 2019 18:02:47 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jun 2019 15:02:45 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga006.fm.intel.com with ESMTP; 11 Jun 2019 15:02:44 -0700
Date:   Tue, 11 Jun 2019 15:02:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     Cedric Xing <cedric.xing@intel.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        jarkko.sakkinen@linux.intel.com, luto@kernel.org,
        jmorris@namei.org, serge@hallyn.com, paul@paul-moore.com,
        eparis@parisplace.org, jethro@fortanix.com, dave.hansen@intel.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, nhorman@redhat.com,
        pmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        bp@alien8.de, josh@joshtriplett.org, kai.huang@intel.com,
        rientjes@google.com, william.c.roberts@intel.com,
        philip.b.tricca@intel.com
Subject: Re: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in
 SELinux
Message-ID: <20190611220243.GB3416@linux.intel.com>
References: <cover.1560131039.git.cedric.xing@intel.com>
 <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 11, 2019 at 09:40:25AM -0400, Stephen Smalley wrote:
> I haven't looked at this code closely, but it feels like a lot of
> SGX-specific logic embedded into SELinux that will have to be repeated or
> reused for every security module.  Does SGX not track this state itself?

SGX does track equivalent state.

There are three proposals on the table (I think):

  1. Require userspace to explicitly specificy (maximal) enclave page
     permissions at build time.  The enclave page permissions are provided
     to, and checked by, LSMs at enclave build time.

     Pros: Low-complexity kernel implementation, straightforward auditing
     Cons: Sullies the SGX UAPI to some extent, may increase complexity of
           SGX2 enclave loaders.

  2. Pre-check LSM permissions and dynamically track mappings to enclave
     pages, e.g. add an SGX mprotect() hook to restrict W->X and WX
     based on the pre-checked permissions.

     Pros: Does not impact SGX UAPI, medium kernel complexity
     Cons: Auditing is complex/weird, requires taking enclave-specific
           lock during mprotect() to query/update tracking.

  3. Implement LSM hooks in SGX to allow LSMs to track enclave regions
     from cradle to grave, but otherwise defer everything to LSMs.

     Pros: Does not impact SGX UAPI, maximum flexibility, precise auditing
     Cons: Most complex and "heaviest" kernel implementation of the three,
           pushes more SGX details into LSMs.

My RFC series[1] implements #1.  My understanding is that Andy (Lutomirski)
prefers #2.  Cedric's RFC series implements #3.

Perhaps the easiest way to make forward progress is to rule out the
options we absolutely *don't* want by focusing on the potentially blocking
issue with each option:

  #1 - SGX UAPI funkiness

  #2 - Auditing complexity, potential enclave lock contention

  #3 - Pushing SGX details into LSMs and complexity of kernel implementation


[1] https://lkml.kernel.org/r/20190606021145.12604-1-sean.j.christopherson@intel.com
