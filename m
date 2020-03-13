Return-Path: <SRS0=tI1m=46=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15275C10DCE
	for <linux-sgx@archiver.kernel.org>; Fri, 13 Mar 2020 16:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DADCD206BE
	for <linux-sgx@archiver.kernel.org>; Fri, 13 Mar 2020 16:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgCMQd2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 13 Mar 2020 12:33:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:20734 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgCMQd2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 13 Mar 2020 12:33:28 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Mar 2020 09:33:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,549,1574150400"; 
   d="scan'208";a="278284491"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 13 Mar 2020 09:33:26 -0700
Date:   Fri, 13 Mar 2020 09:33:26 -0700
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
        cedric.xing@intel.com, Patrick Uiterwijk <puiterwijk@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200313163326.GB5181@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepO2=KCzT+wdXWz2tUNvi6NyzNJ3KwvBMtH_P1TO8Yr_mQ@mail.gmail.com>
 <20200313005252.GA1292@linux.intel.com>
 <CAOASepMN1fmDaPjJJ-rpbLNPGUzE2LNB69s3X5mDBEhXziZ_UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOASepMN1fmDaPjJJ-rpbLNPGUzE2LNB69s3X5mDBEhXziZ_UQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 13, 2020 at 12:07:55PM -0400, Nathaniel McCallum wrote:
> On Thu, Mar 12, 2020 at 8:52 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > FWIW, if the handler reaaaly wanted to pop off the stack, it could do so,
> > fixup the stack, and then re-call __vdso_sgx_enter_enclave() instead of
> > returning (to the original __vdso_sgx_enter_enclave()).
> 
> My understanding from the documentation issue above was that *if* you
> wanted to push parameters back on the stack during enclave exit, you
> would *have* to supply a handler so it could pop the parameters and
> reset the stack. Which is why restoring %rsp from %rbx didn't make
> sense to me.

Yep.
