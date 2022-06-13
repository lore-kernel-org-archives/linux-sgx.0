Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 716D7C43334
	for <linux-sgx@archiver.kernel.org>; Mon, 13 Jun 2022 07:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238559AbiFMHKV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 13 Jun 2022 03:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbiFMHKV (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 13 Jun 2022 03:10:21 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B70F19F95
        for <linux-sgx@vger.kernel.org>; Mon, 13 Jun 2022 00:10:20 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id u2so4995196pfc.2
        for <linux-sgx@vger.kernel.org>; Mon, 13 Jun 2022 00:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding:thread-index:content-language;
        bh=5kNr1QBwci2xn8v1i7qCLrZ1ihQQUbVpWcDqiVqptCg=;
        b=PkWABaMlSag6APioihHV3O0dxdRzhNehDXF3ejpv+Mp84L+hh/taxEfoIWZnS6DjJ9
         VNeHYgAUaqbE7++ZPVjO5LMsN1xNYsMz/B5+zG+gY8HQqwXKm/U8T3sk4lOC8a0VpOk1
         P8WynvurhwgnYDBh9NOAaDN2dP1MRZ9wVv2MgFZg8L4hvTyvtBI1hGd9BDZa4vWwkHnJ
         N7ozL/BkKb0jzYY8G+K+i/8EqTG+flwjf4qu2BgU/pl3XhIb15W8XrDsUNH/m5/KqlYa
         rAHp566b92JXXVROiVWDe6jd0jTzvxNA0bjcRDCj3YSugcXKBOQBWx6v8Bp4vbW2S0AI
         0bpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding:thread-index:content-language;
        bh=5kNr1QBwci2xn8v1i7qCLrZ1ihQQUbVpWcDqiVqptCg=;
        b=T0uSXEEr9Ggsic2+1/GaPqqj9KqFpL1Uoo6a36Ue0c6prYXIrYcWP8xeSKt/MnI2PI
         p4FKkvhMksV92+/gZ+uajfkQsMfddw4gFnV7oixczwN9gT2AdPFX3FTMGNblYuLLfAXB
         Iuehl4rzRLuQBoMSG5PrewEoZw8fQef6LtvJmaOD3hoMAaDDH0x9dveBrC79CFURjvmO
         bRcG1RclLUcJDrFK4/0ffLnhTqBkzu/b4P063er7Ux/JwPEx9EqQ0nTicIopwOD7ZPw5
         JsDg4kkSbQmpjGO5jv1zrEIBZCcBQA0sCwWKhFFwq5VqXpwxLwhOIZZfyoaXDFUqR+5R
         jJ/g==
X-Gm-Message-State: AOAM530534OriX84HmhyhLr8jA+3RYqFddGE8Hv/VeHCGzZbpF5vMRa/
        OSQ3PqEucz22ybVu4CZOd6C3lNguSxwd2Q==
X-Google-Smtp-Source: ABdhPJwBJr0GMilz+13eiL72O7cGTGg1XvoyxGQInvEtpaXQGHMpSCz86flZWXKOS8oCrW/yvdVWww==
X-Received: by 2002:a63:6b02:0:b0:3fb:da5e:42a1 with SMTP id g2-20020a636b02000000b003fbda5e42a1mr51103771pgc.273.1655104219930;
        Mon, 13 Jun 2022 00:10:19 -0700 (PDT)
Received: from DESKTOPAU6EK0I ([144.214.0.53])
        by smtp.gmail.com with ESMTPSA id jb2-20020a170903258200b0015e8d4eb25asm4258332plb.164.2022.06.13.00.10.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jun 2022 00:10:19 -0700 (PDT)
From:   <xymeng16@gmail.com>
To:     <linux-sgx@vger.kernel.org>
Cc:     "'Xiangyi Meng'" <xymeng16@gmail.com>, <alex@unikraft.org>,
        "'MENG Xiangyi'" <xy.meng@my.cityu.edu.hk>
Subject: Inquiry about the license of the OOT linux-sgx-driver
Date:   Mon, 13 Jun 2022 15:10:17 +0800
Message-ID: <003b01d87ef4$a4037680$ec0a6380$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: Adh+9J8JOlovgEwLT0Cqg3efcOKWlw==
Content-Language: en-us
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Dear all,

Greetings!

This is Xiangyi Meng, working on adding SGX support to Unikraft
(https://unikraft.org/, repo at https://github.com/unikraft/unikraft), a
Unikernel solution that is under active development. This work, at its
initial phase, needs us to port the OOT linux-sgx-driver to Unikraft, which
follows BSD 3-clause license. However, during the porting process, I am
aware that the OOT linux-sgx-driver is licensed under two license:

	(a) a 3-clause BSD license; or alternatively
	(b) the GPL v2 license.

Here I wonder, does such "dual-license" explicitly mean the OOT driver can
be redistributed as either one or the other? Sorry for bothering all of you
in this mail list but we need to clarify this before we can continue on this
porting work. 

Thank you very much!

Best Regards,
Xiangyi Meng

