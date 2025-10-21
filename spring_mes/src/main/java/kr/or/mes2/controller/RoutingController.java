package kr.or.mes2.controller;

import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.UUID;
import javax.servlet.ServletContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import kr.or.mes2.dto.RoutingDTO;
import kr.or.mes2.service.RoutingService;

@Controller
@RequestMapping("/master/routing")
public class RoutingController {

	@Autowired
	private RoutingService service;

	@Autowired
	private ServletContext ctx;

	// 조회 + 검색
	@GetMapping
	public String list(@RequestParam(value="itemId", required=false) Integer itemId,
	                   @RequestParam(value="keyword", required=false) String keyword,
	                   Model model) {
	    List<Map<String,Object>> equips = service.equipOptions();

	    model.addAttribute("equipOptions", equips);
	    model.addAttribute("itemOptions", service.itemOptions());
	    model.addAttribute("list", service.list(itemId, keyword));
	    model.addAttribute("selectedItemId", itemId);
	    model.addAttribute("keyword", keyword);
	    System.out.println("equipOptions size = " + (equips != null ? equips.size() : -1));
	    return "master/routing";
	}



	// 등록
	@PostMapping("/insert")
	@ResponseBody
	public String insert(@ModelAttribute RoutingDTO dto,
			@RequestParam(value = "imgFile", required = false) MultipartFile imgFile) throws IOException {
		dto.setImgPath(saveUpload(imgFile));
		service.insert(dto);
		return "success";
	}

	// 수정
	@PostMapping("/update")
	@ResponseBody
	public String update(@ModelAttribute RoutingDTO dto,
			@RequestParam(value = "imgFile", required = false) MultipartFile imgFile) throws IOException {

		// 새 이미지 업로드 시 교체
		if (imgFile != null && !imgFile.isEmpty()) {
			dto.setImgPath(saveUpload(imgFile));
		} else {
			// 기존 이미지 유지
			RoutingDTO origin = service.findById(dto.getRoutingId());
			if (origin != null && origin.getImgPath() != null) {
				dto.setImgPath(origin.getImgPath());
			}
		}

		int updated = service.update(dto);
		return updated > 0 ? "success" : "fail";
	}

	// 삭제
	@PostMapping("/delete")
	@ResponseBody
	public String delete(@RequestParam int routingId) {
		service.delete(routingId);
		return "success";
	}

	// 파일 저장 유틸
	private String saveUpload(MultipartFile file) throws IOException {
		if (file == null || file.isEmpty())
			return null;
		String base = "/upload/routing";
		String real = ctx.getRealPath(base);
		File dir = new File(real);
		if (!dir.exists())
			dir.mkdirs();

		String ext = "";
		String original = file.getOriginalFilename();
		if (StringUtils.hasText(original) && original.contains(".")) {
			ext = original.substring(original.lastIndexOf('.'));
		}
		String saved = UUID.randomUUID().toString().replaceAll("-", "") + ext;
		file.transferTo(new File(dir, saved));
		return base + "/" + saved;
	}
}
