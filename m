Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A6AC433F5
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Oct 2022 13:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiJDNWT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Oct 2022 09:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiJDNWO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 4 Oct 2022 09:22:14 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34F65072A
        for <linux-sgx@vger.kernel.org>; Tue,  4 Oct 2022 06:22:13 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 70AFB3200413;
        Tue,  4 Oct 2022 09:22:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 04 Oct 2022 09:22:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1664889730; x=1664976130; bh=rF9Tz2/xyU
        q1k79tlSYkyEdiumZJ2g4Uk4uR81enuf0=; b=3V9nP7XL4TdUVY4/8afef0kHIe
        z2L3QbZedOCf95ZSHYnkNjrgitdrIY8MBhpd/L+tSkgQqFG5OHn5Sho56hhRgIa0
        3PeiSWeizE/YsCh1po5LS5/Cr06PGoYhGRQq6zyC44KOv/oF1FCM4iDk27NgiSDE
        agpNcwK+6/RjUmGI6GnUKVN5Gf3wK3KBaJKEt02NgrJGjbTkeKShpNZrQEwnynG8
        KPrK9sRLYzED3O60M4IqVdAl0hDqlPuv5E2QRUU1a6QfGE/+zW08OY0Y08FqxO7z
        20jpqdxaqMYMjGV48rrQEX7OqBQCFPUw4JZzV4JsaxPAJkQNwvgGqx110IFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1664889730; x=
        1664976130; bh=rF9Tz2/xyUq1k79tlSYkyEdiumZJ2g4Uk4uR81enuf0=; b=t
        3XKYii6VpktHEfQ8ZE1mfvFGdrx0dFoKfCDE3kR7VTH31O86k4owcivnC26S6px2
        cJF/VJa50LEIGjkf2BT8bqkHYS5POnYkZOO+DNV3VyCR8MPXt0x8AboLkN2TaQCq
        O1TUmMcCrtCKyuDrzrw9ZBHQfpDeZOSgd6FJZLaijB1lriWIpndhc2wd5Auwkkd0
        gKEPW6aX/hZQYM3b3R2jDa02+0rfwxmOIBb+Vv5gkeA2u6UZNX78AUuFG5r+VTXm
        p/KAku5wVPLlAPIrRxspEatgqUPDafh5tVFhwx5GY0zgM3DIUqQH8xEXGZv+aTkW
        KA39GvPR4UWn2ZYt3k/Rg==
X-ME-Sender: <xms:gTM8Y55s9_hxzEV9gDAvLohALLCrl_BROWrooY2hFWxGOam15e2l-w>
    <xme:gTM8Y25Pjbp-Pslly3A2-twccbidURIsBzpF1DxaqpInXZKrkajS7506yqimEOi-m
    6-LSR95ixJHyx8>
X-ME-Received: <xmr:gTM8Ywf-T_gW6s_9wzSwGB-bQ-WnRlCopvFBwB9l28V94p_n0AFgNLGab3Daf2IS5cgQAaUAKSvVqEq8XckhvCPF>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeeiuddgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtfeejnecuhfhrohhmpeeuohhr
    hihsuceosghorhihshhpsehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqne
    cuggftrfgrthhtvghrnhepgeelfeegueefgfejtdevheegffduudehgfdtjeegtdfhteev
    feethfeiieefhffgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepsghorhihshhpsehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:gTM8YyLfoB2rA2TlHCUg1aYZW_wG7jYuyjt9WawbEKEE9gG6ErqOsQ>
    <xmx:gTM8Y9JRk5EYO0Wll9fMNeOibDFJuxYBtSEYifZ-_pyuFapJxEIw_g>
    <xmx:gTM8Y7weu2HBjfoeBR7s4oKl5rly8L6b2uWn73nhUyos4RThKEZ_AQ>
    <xmx:gjM8Y0UH9EE-jcoYTRDzdFT1eudcspMcgNMtOS4GwiQXhvGzUAu9Nw>
Feedback-ID: i21414460:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 4 Oct 2022 09:22:08 -0400 (EDT)
Message-ID: <703f49cb-7edd-9ac5-4202-0e799e1a98a4@invisiblethingslab.com>
Date:   Tue, 4 Oct 2022 15:22:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: sgx_validate_offset_length bug
Content-Language: en-US
To:     Reinette Chatre <reinette.chatre@intel.com>, jarkko@kernel.org,
        dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org
Cc:     mkow@invisiblethingslab.com
References: <9e1e61cf-39d9-8039-b2e4-f0a3804fe493@invisiblethingslab.com>
 <956f6af2-e0cb-72c0-abf8-e2e00067851c@intel.com>
 <5b3bc4ce-bdfa-285e-79e0-77a85616e637@intel.com>
From:   Borys <borysp@invisiblethingslab.com>
In-Reply-To: <5b3bc4ce-bdfa-285e-79e0-77a85616e637@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi,

On 10/3/22 19:58, Reinette Chatre wrote:
> Hi Borys,
>
> On 10/3/2022 10:33 AM, Reinette Chatre wrote:
>> On 10/3/2022 10:19 AM, Borys wrote:
>>> I've stumbled upon "sgx_validate_offset_length" function in
>>> "arch/x86/kernel/cpu/sgx/ioctl.c" (all of this is based on 6.0-rc7
>>> version), which does not entirely do what it claims. "offset" and
>>> "length" parameters are provided by userspace and as such their
>>> addition can overflow, which may result in this function approving
>>> malicious values. Fortunately this does not result in any exploitable
>>> bugs at the moment (or at least I couldn't find any), but this might
>>> change if "sgx_validate_offset_length" is used in a new context or
>>> current usages are changed, so it might be worth fixing anyway.
>>> Simple overflow check `offset + length < offset` should be enough.>
>> Could you please elaborate where you see a possibility for overflow?
>>
>> Together the provided values, offset and length, are already ensured to
>> not exceed the total size of the enclave in the following check:
>>
>> sgx_validate_offset_length() {
>> 	...
>> 	if (offset + length - PAGE_SIZE >= encl->size)
>> 		return -EINVAL;
>> 	...
>> }
> I think I see what you mean now ... if offset and length are
> sufficiently large the above check can still pass but loops
> that have the following pattern may have issues:
>
> for (c = 0 ; c < length; c += PAGE_SIZE) {
>
> 	...
> 	/* do something at <offset> */
>
> }
>
> Are you planning to submit a patch for the check you propose?
>
> Reinette

Sure, I'll try to submit a patch later today.

Borys

