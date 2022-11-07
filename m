Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 275F6C433FE
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Nov 2022 11:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiKGLgh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Nov 2022 06:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiKGLgg (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 7 Nov 2022 06:36:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D8419C0E
        for <linux-sgx@vger.kernel.org>; Mon,  7 Nov 2022 03:36:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D3EE60FDF
        for <linux-sgx@vger.kernel.org>; Mon,  7 Nov 2022 11:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02577C433C1;
        Mon,  7 Nov 2022 11:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667820995;
        bh=1XcXQRs4BclTrwbxf64ITfajC8h2TP/Por1YM/kjh0Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ObFUUIGI2WtQtoFQAcGpw6xl//gtyqzFMRfPOOqjWGqezvJexnlhzcyXTn6XRTnPj
         uf7z5MKfi+yo+8w7k2eY7YWC4w2Sm00VJdRnDQ6RDmAxBSo8mka7NvHpoN7p1Z45Bc
         KerYiIlIMs/c6tTQWsnSe/sdETSq7CYSOQSmA47VuLfjA9Y3l6q9kqyQm08To+hdrF
         X9UkkKGFVU/GK5EkdyZehUGLI/9paUicKHn65wUnnsFIzFayCPwPPFrNmhrw4UR7PF
         b4qONNhSOrWanHNtBL9MfuKZ55eLMIZWdVej+jzfsxJyWqfL7f8ldVgPF2RI7OsLuG
         si3XxmoMgQCfw==
Date:   Mon, 7 Nov 2022 13:36:26 +0200
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     Zhiquan Li <zhiquan1.li@intel.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>, "bp@suse.de" <bp@suse.de>
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Message-ID: <Y2jtup9Owa7PE9Ug@kernel.org>
References: <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
 <4930999a-888f-88bc-a05c-86762504f059@intel.com>
 <c8e7cff6f8d66ce4f8575caaf69f02b491ed7d90.camel@intel.com>
 <5afff147-dfb4-9033-6826-5965ba0bf3a0@intel.com>
 <061580727e503d092ca3867919fa0f26391568eb.camel@intel.com>
 <10c4b928a37fdf96df767fc7b8f1348f6af05984.camel@intel.com>
 <Y1WmZgqIkl8GkR/i@kernel.org>
 <e8f1e391-0362-33b7-aaf6-45a685eba0a4@intel.com>
 <Y2BsSCM1BWlsqPcK@kernel.org>
 <ff40770e-dd55-e869-53cb-ea976bc5f63f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff40770e-dd55-e869-53cb-ea976bc5f63f@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 02, 2022 at 09:38:55AM +0800, Zhiquan Li wrote:
> 
> On 2022/11/1 08:46, jarkko@kernel.org wrote:
> > Why would we want to enforce for user space not to do this, even
> > if it does cause malfunctioning program?
> > 
> 
> We want to resolve the problem at the source rather than just deal with
> the symptom passively derived from it. For instance, we might be able to
> return VM_FAULT_SIGBUS to kill the malicious application, but if the
> malicious child touch the memory earlier than parent despite it cannot
> use the virtual EPC page, then the parent will be victim.
> 
> Even thought it's not a security threaten, there is no practical
> significance for sharing a virtual EPC instance. So we would like to
> prevent it from the beginning.

Can you phrase this to the commit message? This makes sense as a
motivation.

BR, Jarkko

