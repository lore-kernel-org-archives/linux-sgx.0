Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70ADFC433DB
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Feb 2021 00:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 385F964E04
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Feb 2021 00:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhBAAeJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 31 Jan 2021 19:34:09 -0500
Received: from mga03.intel.com ([134.134.136.65]:16598 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229765AbhBAAdp (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 31 Jan 2021 19:33:45 -0500
IronPort-SDR: nLNcW8/7CjMtdMhpKAQL++NQhkxs2f1BmcmAeHkBcBuYK+et76kB8BqUCST3vA7deKZpHV/R0U
 GEvSsNPgcACA==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="180693128"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="180693128"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 16:33:05 -0800
IronPort-SDR: DilUVe739Ls5IMR4qgDV2+BZZdW+nSoo5Fwh+x4f1HUlrxJwGvQ2YGQgJ5DE0kBga3S+Do7Bt0
 6QbC11WC0dQw==
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="368699782"
Received: from kpeng-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.130.129])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 16:33:01 -0800
Date:   Mon, 1 Feb 2021 13:32:59 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com
Subject: Re: [RFC PATCH v3 16/27] KVM: VMX: Convert vcpu_vmx.exit_reason to
 a union
Message-Id: <20210201133259.e0398c9f0b229fd79a8c16c6@intel.com>
In-Reply-To: <YBV0nnqUHnING5qA@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
        <d32ab375be78315e3bc2540f2a741859637abcb0.1611634586.git.kai.huang@intel.com>
        <YBV0nnqUHnING5qA@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, 30 Jan 2021 17:00:46 +0200 Jarkko Sakkinen wrote:
> On Tue, Jan 26, 2021 at 10:31:37PM +1300, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Convert vcpu_vmx.exit_reason from a u32 to a union (of size u32).  The
> > full VM_EXIT_REASON field is comprised of a 16-bit basic exit reason in
> > bits 15:0, and single-bit modifiers in bits 31:16.
> > 
> > Historically, KVM has only had to worry about handling the "failed
> > VM-Entry" modifier, which could only be set in very specific flows and
> > required dedicated handling.  I.e. manually stripping the FAILED_VMENTRY
> > bit was a somewhat viable approach.  But even with only a single bit to
> > worry about, KVM has had several bugs related to comparing a basic exit
> > reason against the full exit reason store in vcpu_vmx.
> > 
> > Upcoming Intel features, e.g. SGX, will add new modifier bits that can
> > be set on more or less any VM-Exit, as opposed to the significantly more
> > restricted FAILED_VMENTRY, i.e. correctly handling everything in one-off
> > flows isn't scalable.  Tracking exit reason in a union forces code to
> > explicitly choose between consuming the full exit reason and the basic
> > exit, and is a convenient way to document and access the modifiers.
> 
> I *believe* that the change is correct but I dropped in the last paragraph
> - most likely only because of lack of expertise in this area.
> 
> I ask the most basic question: why SGX will add new modifier bits?

Not 100% sure about your question. Assuming you are asking SGX hardware
behavior, SGX architecture adds a new modifier bit (27) to Exit Reason, similar
to new #PF.SGX bit. 

Please refer to SDM Volume 3, Chapter 27.2.1 Basic VM-Exit Information.

Sean's commit msg already provides significant motivation of the change in this
patch.
