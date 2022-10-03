Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15181C433FE
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Oct 2022 17:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiJCRT2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiJCRT1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 3 Oct 2022 13:19:27 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A38B481
        for <linux-sgx@vger.kernel.org>; Mon,  3 Oct 2022 10:19:26 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 139BB5C0148;
        Mon,  3 Oct 2022 13:19:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 03 Oct 2022 13:19:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1664817564; x=1664903964; bh=l4DrGLV0UMnLuvbNc2YP4CWAqO+tyIzFecA
        OwfD9ydY=; b=E+yr3jk1rcyws3zEZWXUguvLXFN3IK0JzrrKMNAsQuPTEveP/Fw
        eVh8EZTqCfXQbyniV/nnVpDVCA7BqvCLg46kfWiFMF3GXM7QYsAkXllJOCYqEMlw
        XHuR2BK+0KCdq+s95qy0CQgOoJGO/6HdbzSFjNSEcYzsmPQMgLap2mmOWHzYCweQ
        HqE1naxGUbVI/U/9pngYfnrEBIprRDXgQ4M5mtDtbnxoxse93WkzkDppGiwtP801
        ZcF+x5dmTsJJV36BQxdDqlh0t5IwRN1CfGekcaGw1JQO/hUDH150XlWwyiJaDEkX
        NygqfjkjENXOirRzrW/boFYwYIvbA8J0h4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1664817564; x=1664903964; bh=l4DrGLV0UMnLu
        vbNc2YP4CWAqO+tyIzFecAOwfD9ydY=; b=O3IZhX9Tb9KMPd+qpB3qMSCR+eBYd
        ypktaPABYbG2wb9j2SGhoHn8YoZf2elEVkCEG+vVcbBzxdaDxOA4mfEjXVmHXOmN
        7c2TYmRcY7mK/2IrrsnQqx2q4pefzxJcDCANz/EIZQ082e9Bv/wl+gVZEhg9qoi3
        kxlik+oNO98qat06wln5UQSId+AkQCNNgNeG1JINrYLTUjdMZbM58A0AwKl3hnN8
        Hbwlu88nHo/DhqWFVjpa5n7lQN9XACSfTn+wsJX3SkT/4WZb8wqDuL3PxP9ltGcx
        eYjkShyOMEFSvDxrigXl6GXxc2JNqUIZFJRZE8BSf4/FtXXgyko8fPkaA==
X-ME-Sender: <xms:mxk7Y37ifO3bHxf6fBeZ9tQcpxDOvlIwDGp-z0UUQqEHCWNcBVIPAQ>
    <xme:mxk7Y86_x6ns7p_x_wi134A-klHOJL_PzBVrpkoaL9n2xjBNXobnXxdF2qKL_OlDG
    wbSzJcjEJomSLg>
X-ME-Received: <xmr:mxk7Y-cWqC1O1seiY4j0Vlo_f5RZfjXPz8_FQdEfQT_cCDSzbsjZRgPA2COUjpY-ZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeehledguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepkfffgggfhffvvefutgfgsehtje
    ertddtfeejnecuhfhrohhmpeeuohhrhihsuceosghorhihshhpsehinhhvihhsihgslhgv
    thhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepuefhhfelffetvdegue
    euleduvdejveekheeggfdvjedtudefheehjeduueethfeknecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhihshhpsehinhhvihhsihgslh
    gvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:mxk7Y4K2_Cju65CbxQt7Ydcpb_dkXuvzx_cC3daZzIrTorP8hyefXg>
    <xmx:mxk7Y7JFrrdP2_v2HTF3cStIP6NuZAzVpw9ifBprN4Prs6JshvqlkA>
    <xmx:mxk7Yxw10OSWGBIgMWOyHa9pzpyEibWA972SNMNI14PbP04yi89-BQ>
    <xmx:nBk7YxhQD3jmoQRMetAHgHd5z9QpNYmhS7ocJxaDjWJsy2N-TtSRmQ>
Feedback-ID: i21414460:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 3 Oct 2022 13:19:22 -0400 (EDT)
Message-ID: <9e1e61cf-39d9-8039-b2e4-f0a3804fe493@invisiblethingslab.com>
Date:   Mon, 3 Oct 2022 19:19:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
From:   Borys <borysp@invisiblethingslab.com>
To:     jarkko@kernel.org, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org
Cc:     mkow@invisiblethingslab.com
Subject: sgx_validate_offset_length bug
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi,

I've stumbled upon "sgx_validate_offset_length" function in "arch/x86/kernel/cpu/sgx/ioctl.c" (all of this is based on 6.0-rc7 version), which does not entirely do what it claims. "offset" and "length" parameters are provided by userspace and as such their addition can overflow, which may result in this function approving malicious values. Fortunately this does not result in any exploitable bugs at the moment (or at least I couldn't find any), but this might change if "sgx_validate_offset_length" is used in a new context or current usages are changed, so it might be worth fixing anyway. Simple overflow check `offset + length < offset` should be enough.

Best regards,

Borys

