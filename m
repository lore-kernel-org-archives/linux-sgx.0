Return-Path: <SRS0=dOd4=DC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBE9C47420
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 18:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54C7D20878
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 18:31:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="efwMEia9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgIYSbT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 25 Sep 2020 14:31:19 -0400
Received: from esa1.hc3370-68.iphmx.com ([216.71.145.142]:43695 "EHLO
        esa1.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729770AbgIYSbT (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 25 Sep 2020 14:31:19 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Sep 2020 14:31:18 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1601058679;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=KQIseKj8hPAc0sTy5JS3YOK8gQLhL2Bj/MDaVmWNBkM=;
  b=efwMEia9j6jq5JBDXblRRFAbD4Vgc9o27lM5tCfFyusjQEZizmDzibat
   XuB9oKM1CgmD6es0mOcRxO8vI1M1/QFNO6cYdXf9sYcNnuvqHtXH3MNS3
   2ek/lkJwaHG1j33ZMbFIZqGAzTrast3x40XWmnRDp/qPHByfVAxRTaTzc
   w=;
Authentication-Results: esa1.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: WxK14DcGcBBBJxAfO7wg1u2a28zTr+BplMR0Byabqcp5UikVj9vLpwUsQQ6ZOEg7UWA27G74OL
 6tqRv5coUPYHYzZlevyKsRwlZnHtcVspMgcgkZlT9Y2oNHL0U5SjLiyjmnnaZcyTDobTA4fuVP
 vJD68xg6kNOTGFuuqmNKNKMCjqA6JXbsbkPEmT801fLQU3YSVrnKTTVu28TaojqnvIk9L0TSyE
 ttLVPXnb4O6EfhhJYJ110nGc0NKFAFutDmqMyGfW5CkIuvSCohEoe3zaUty1kuM0+7/ZjaC8/b
 8jQ=
X-SBRS: None
X-MesageID: 27957229
X-Ironport-Server: esa1.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.77,302,1596513600"; 
   d="scan'208";a="27957229"
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        <x86@kernel.org>, <linux-sgx@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        <akpm@linux-foundation.org>, <andriy.shevchenko@linux.intel.com>,
        <asapek@google.com>, <bp@alien8.de>, <chenalexchen@google.com>,
        <conradparker@google.com>, <cyhanish@google.com>,
        <dave.hansen@intel.com>, <haitao.huang@intel.com>,
        <josh@joshtriplett.org>, <kai.huang@intel.com>,
        <kai.svahn@intel.com>, <kmoy@google.com>, <ludloff@google.com>,
        <luto@kernel.org>, <nhorman@redhat.com>, <npmccallum@redhat.com>,
        <puiterwijk@redhat.com>, <rientjes@google.com>,
        <tglx@linutronix.de>, <yaozhangx@google.com>,
        "H.J. Lu" <hjl.tools@gmail.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <721ca14e-21df-3df1-7bef-0b00d0ff90c3@citrix.com>
Date:   Fri, 25 Sep 2020 19:23:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-ClientProxiedBy: AMSPEX02CAS02.citrite.net (10.69.22.113) To
 FTLPEX02CL05.citrite.net (10.13.108.178)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 15/09/2020 12:28, Jarkko Sakkinen wrote:
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> new file mode 100644
> index 000000000000..adbd59d41517
> --- /dev/null
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -0,0 +1,157 @@
> +SYM_FUNC_START(__vdso_sgx_enter_enclave)
> <snip>
> +.Lretpoline:
> +	call	2f
> +1:	pause
> +	lfence
> +	jmp	1b
> +2:	mov	%rax, (%rsp)
> +	ret

I hate to throw further spanners in the work, but this is not compatible
with CET, and the user shadow stack work in progress.

Whichever of these two large series lands first is going to inflict
fixing this problem on the other.

As the vdso text is global (to a first approximation), it must not be a
retpoline if any other process is liable to want to use CET-SS.

If the retpoline really does need to stay, then the vdso probably needs
to gain suitable __x86_indirect_thunk_%reg thunks which are patched at
boot based on the system properties.

~Andrew
