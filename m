Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9187EC433F5
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Oct 2022 23:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiJDXCo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Oct 2022 19:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiJDXCn (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 4 Oct 2022 19:02:43 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237C14686A
        for <linux-sgx@vger.kernel.org>; Tue,  4 Oct 2022 16:02:43 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 6A7593200916;
        Tue,  4 Oct 2022 19:02:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 04 Oct 2022 19:02:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1664924562; x=1665010962; bh=+Kf2t+awbn
        0Iu3s8PD663EMDThErKEhK7wEDj/x6yLA=; b=nmAQOeoK8sD4ntxrMtbHe8rP/p
        SwMCuQXTmwnrAVdIrosY7HzfYkJR35nJLjHRbRE3d2bWpxFNdyiy0qf/wdN0Waa5
        A73AQHenVNSdGnNvWHiKPW99WsAV3t2U6EZXdwP8BuPoUly15liGX4A+9uwdPeFS
        6RefyqTIc7tEPr4NwyrUfLT9OxArmmIrLgN+g79x0JK8BsY/gD4ovHImBnlanWse
        HHI+Y7BF52V478W8TM9GnUz6/ISKvpYzHNLF+X+ozrmwofZQxMTBO2+eAt05bWol
        hh+0qMAF1vk4PelD+9vlQgNJt0klemLwbJsf52KUIZbelIJA32SAqoL5/h9Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1664924562; x=
        1665010962; bh=+Kf2t+awbn0Iu3s8PD663EMDThErKEhK7wEDj/x6yLA=; b=g
        rIRG42ASZNOrwR+hF3UXnb+bkTsecXJEwY8eMgTrhBOI+USEbPVKHJI791VzXP6R
        J7oSw6K1VVdmQ7Nc9AF4OVlXYUS1sCi0j+IrtSf+J1QMZx416WR6yeugrVgoVCFs
        gRW/8I/8K/D3nLpUgrH6gb0109eNA7eYLLcTV1GlbFfVRFEvHcm+1ggB6U4ewNqe
        Q7iOeyLoMdJ5W77cDRRpWO/PI2P+20yj7hN9NPRWb17odsCEvj2Yr06nT9XNtL5I
        VtXhkQY6nLYHrLLSL01citn4TT3iKDkeyLFEIvwsjDJ8Pkp/XIA7463/5GJfI6qC
        lCQDeNvLOz0ylk32S3AHg==
X-ME-Sender: <xms:kbs8Y5kcLNEJkZOsAYyktISOC36gmMetMPR_k_qg395RP56jdvoYTg>
    <xme:kbs8Y02_ewRmlY77LvnjpUvDV2J3Vm2etf95tk2lckVmv1mrOZ7tehgA97md4W0UD
    ql2b4pKzlpoB1E>
X-ME-Received: <xmr:kbs8Y_r56y4SXdpQGDDdSES7s9hM9A0Xe_Yr6oaxg2twi2TO7GA6o-5EYj3Exr7AHxW7F3AfIRPEDtKNQ4xJXzUZ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeeivddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfvfevfhfhufgjtgfgsehtjeertddtfeejnecuhfhrohhmpeeuohhr
    hihsuceosghorhihshhpsehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqne
    cuggftrfgrthhtvghrnhepteetteegfeefveevgfejgfeiueelgeevueettdelledtuddu
    heehfeehhfefjeeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepsghorhihshhpsehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:kbs8Y5l3a4CFHc7X6QOuI-BZKMMPv5U6ebIrjgZ7KgjsG-oQI_q7cQ>
    <xmx:kbs8Y30mhWZudXIuVlM3ARdvu4FsXn_yzMd4WEe4Sr4cwzrFtKb4IA>
    <xmx:kbs8Y4tNaKlFSWEnlmgcVta6Oen65ENB_4zmRErMcSTq66IfjVvckA>
    <xmx:krs8Yw99lrj2WJXzOtTDxXHhSPQhOHRfM4vfFSVF4QFFGW7VfkLOfQ>
Feedback-ID: i21414460:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 4 Oct 2022 19:02:41 -0400 (EDT)
Message-ID: <65cc7f00-30e8-3cd4-7c1c-c50ca1e0bd42@invisiblethingslab.com>
Date:   Wed, 5 Oct 2022 01:02:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        mkow@invisiblethingslab.com
References: <9e1e61cf-39d9-8039-b2e4-f0a3804fe493@invisiblethingslab.com>
 <YzyqttbWmjqzH7At@kernel.org>
From:   Borys <borysp@invisiblethingslab.com>
Subject: Re: sgx_validate_offset_length bug
In-Reply-To: <YzyqttbWmjqzH7At@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 10/4/22 23:50, Jarkko Sakkinen wrote:
> On Mon, Oct 03, 2022 at 07:19:21PM +0200, Borys wrote:
>> Hi,
>>
>> I've stumbled upon "sgx_validate_offset_length" function in
>> "arch/x86/kernel/cpu/sgx/ioctl.c" (all of this is based on 6.0-rc7
>> version), which does not entirely do what it claims. "offset" and
>> "length" parameters are provided by userspace and as such their addition
>> can overflow, which may result in this function approving malicious
>> values. Fortunately this does not result in any exploitable bugs at the
>> moment (or at least I couldn't find any), but this might change if
>> "sgx_validate_offset_length" is used in a new context or current usages
>> are changed, so it might be worth fixing anyway. Simple overflow check
>> `offset + length < offset` should be enough.
>>
>> Best regards,
>>
>> Borys
>>
> 
> I agree with the bug but not on security issue.
> 
> If you can call the ioctl API in the first place, you can already apply
> the operations in arbitrary locations inside the enclave, i.e. it does
> not introduce any new capability to the untrusted runtime.
> 
> BR, Jarkko

I meant it could possibly enable some local priv escalation, if other
code has wrong assumptions. But again, this is purely theoretical,
current usages fail on invalid values anyway.

Best regards,
Borys
