Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2503C433E0
	for <linux-sgx@archiver.kernel.org>; Sat, 23 Jan 2021 10:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C87B233EA
	for <linux-sgx@archiver.kernel.org>; Sat, 23 Jan 2021 10:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbhAWKxZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 23 Jan 2021 05:53:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58782 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726997AbhAWKwM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 23 Jan 2021 05:52:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611399037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=z8zmoUh7og5bSNaEIMYknI1IR1asm0XBGCee5/KFO14=;
        b=KWwe+P5GedQVcUHGqNjDwf4RsSIuxVY0L0oWr/UWC8xnkDtYcvAlS4WEmt3yV9sq9SFk9b
        JSqx6tNBb0yQMaABX7QVgaV847UvV2qUkH1izaOq24UcdVEUSXmwVNrh/Sq3zl9Bo7uoZ1
        UZWVAGc9Rt97RqTPzyLX99PcGl5F+vM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-xAt_PtiVPsiobi5A1hf6eg-1; Sat, 23 Jan 2021 05:50:34 -0500
X-MC-Unique: xAt_PtiVPsiobi5A1hf6eg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA43BE750;
        Sat, 23 Jan 2021 10:50:32 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B5375885D;
        Sat, 23 Jan 2021 10:50:32 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 10NAoVPM022060;
        Sat, 23 Jan 2021 05:50:31 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 10NAoVnK022056;
        Sat, 23 Jan 2021 05:50:31 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Sat, 23 Jan 2021 05:50:31 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Sean Christopherson <sean.j.christopherson@intel.com>
cc:     Andy Lutomirski <luto@amacapital.net>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Jethro Beekman <jethro@fortanix.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Subject: [PATCH] x86/vdso: fix a warning with x32 compiler
Message-ID: <alpine.LRH.2.02.2101230548050.21951@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=mpatocka@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: MULTIPART/MIXED; BOUNDARY="185206533-1055175362-1611399031=:21951"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--185206533-1055175362-1611399031=:21951
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

This patch fixes a warning:
arch/x86/entry/vdso/vdso2c.h:38:52: warning: format ¡%lu¢ expects argument of type ¡long unsigned int¢, but argument 4 has type ¡size_t¢ {aka ¡unsigned int¢} [-Wformat=]
when compiling the kernel with x32 compiler.

The reason for the warning is that in x32 mode, size_t is defined as
unsigned, not unsigned long.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 8382c668ce4f ("x86/vdso: Add support for exception fixup in vDSO functions")

---
 arch/x86/entry/vdso/vdso2c.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/entry/vdso/vdso2c.h
===================================================================
--- linux-2.6.orig/arch/x86/entry/vdso/vdso2c.h	2021-01-07 17:22:39.000000000 +0100
+++ linux-2.6/arch/x86/entry/vdso/vdso2c.h	2021-01-23 10:44:09.000000000 +0100
@@ -27,10 +27,10 @@ static void BITSFUNC(extract)(const unsi
 			      FILE *outfile, ELF(Shdr) *sec, const char *name)
 {
 	unsigned long offset;
-	size_t len;
+	unsigned long len;
 
 	offset = (unsigned long)GET_LE(&sec->sh_offset);
-	len = (size_t)GET_LE(&sec->sh_size);
+	len = GET_LE(&sec->sh_size);
 
 	if (offset + len > data_len)
 		fail("section to extract overruns input data");
--185206533-1055175362-1611399031=:21951--

